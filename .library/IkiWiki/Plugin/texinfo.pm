# A GNU Texinfo rendering plugin.

# Copyright © 2007 Thomas Schwinge <tschwinge@gnu.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any later
# version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

# http://ikiwiki.info/plugins/contrib/texinfo/

package IkiWiki::Plugin::texinfo;

use warnings;
use strict;
use IkiWiki 2.00;

# From `Ikiwiki/Plugins/teximg.pm'.
sub create_tmp_dir ($)
{
    # Create a temp directory, it will be removed when ikiwiki exits.
    my $base = shift;

    my $template = $base . ".XXXXXXXXXX";
    use File::Temp qw (tempdir);
    my $tmpdir = tempdir ($template, TMPDIR => 1, CLEANUP => 1);
    return $tmpdir;
}

sub import
{
    hook (type => "filter", id => "texi", call => \&filter);
    hook (type => "htmlize", id => "texi", call => \&htmlize);
    hook (type => "pagetemplate", id => "texi", call => \&pagetemplate);
}

my %copyright;
my %license;

sub filter (@)
{
    my %params = @_;
    my $page = $params{page};

# TODO.  For ``$page eq 'shortcuts''' this fails.  Is this expected?
    goto out unless defined $pagesources{$page};

    # Only care for `.texi' files.
    goto out unless pagetype ($pagesources{$page}) eq 'texi';

    # No need to parse twice.
    goto out if exists $copyright{$page};

# TODO.  Check the `meta' plugin about when to do this at all.
    $copyright{$page} = undef;
    $license{$page} = undef;
    # We assume that the copyright and licensing information is to be taken
    # from the main `.texi' file.
    @_ = split /\n/, $params{content};
    # Do some parsing to cut out the interesting bits, if there are any.
    while (defined ($_ = shift @_))
    {
	# Did we find a start tag?
	last if /^\@copying$/;
    }
    # Already at the end of the page?
    goto out unless defined $_;
    while (defined ($_ = shift @_))
    {
	# Already at the end of the copying section?  (Shouldn't happen.)
	goto out if /^\@end\ copying/;
	# Found the ``^Copyright'' line?
	last if /^Copyright/;
    }
    # Already at the end of the page?  (Shouldn't happen.)
    goto out unless defined $_;
    # Copyright text will follow.
    $copyright{$page} = $_;
    while (defined ($_ = shift @_))
    {
	# Found the separator of copyright and licensind information?
	last if /^$/;
	# Already at the end of the copying section?
	goto finish if /^\@end\ copying/;
	$copyright{$page} .= ' ' . $_;
    }
    # Already at the end of the page?  (Shouldn't happen.)
    goto finish unless defined $_;
    # Licensing text will follow.
    while (defined ($_ = shift @_))
    {
	# Already at the end of the copying section?
	last if /^\@end\ copying/;
	$license{$page} .= ' ' . $_;
    }

  finish:
    # ``Render'' by hand some stuff that is commonly found in this section.
    if (defined $copyright{$page})
    {
	$copyright{$page} =~ s/\@copyright\{\}/©/g;
    }
    if (defined $license{$page})
    {
	$license{$page} =~ s/\@quotation//g;
	$license{$page} =~ s/\@end\ quotation//g;
	$license{$page} =~ s/\@ignore/<!--/g;
	$license{$page} =~ s/\@end\ ignore/-->/g;
    }

  out:
    return $params{content};
}

sub htmlize (@)
{
    my %params = @_;
    my $page = $params{page};

    my $home;
    if (defined $pagesources{$page})
    {
	$home = $config{srcdir} . '/' . dirname ($pagesources{$page});
    }
    else
    {
	# This happens in the CGI web frontent, when freshly creating a
	# `texi'-type page and selecting to ``Preview'' the page before doing a
	# ``Save Page''.
# TODO.
	$home = $config{srcdir};
    }

    my $pid;
    my $sigpipe = 0;
    $SIG{PIPE} = sub
    {
	$sigpipe = 1;
    };

    my $tmp = eval
    {
	create_tmp_dir ("texinfo")
    };
    if (! $@ &&
	# `makeinfo' can't work directly on stdin.
	writefile ("texinfo.texi", $tmp, $params{content}) == 0)
    {
	return "couldn't write temporary file";
    }

    use File::Basename;
    use IPC::Open2;
    $pid = open2 (*IN, *OUT,
		  'makeinfo',
		  '--html',
		  '--no-split', '--output=-',
		  # We might be run from a directory different from the one the
		  # `.texi' file is stored in.
# TODO.  Should we `cd' to this directory instead?
		  '-P', $home,
# TODO.  Adding the following allows for putting files like `gpl.texinfo' into
# the top-level wiki directory.
		  '-I', $config{srcdir},
		  $tmp . "/texinfo.texi");
    # open2 doesn't respect "use open ':utf8'"
    binmode (IN, ':utf8');
#    binmode (OUT, ':utf8'); 

#    print OUT $params{content};
    close OUT;

    local $/ = undef;
    my $ret = <IN>;
    close IN;
    waitpid $pid, 0;
    $SIG{PIPE} = "DEFAULT";

    return "failed to render" if $sigpipe;

    # Cut out the interesting bits.
    $ret =~ s/.*<body>//s;
    $ret =~ s/<\/body>.*//s;

    return $ret;
}

sub pagetemplate (@)
{
    my %params = @_;
    my $page = $params{page};
    my $destpage = $params{destpage};

    my $template = $params{template};

# TODO.  Check the `meta' plugin about when to do this at all.
    if ($template->query (name => "copyright") &&
	! defined $template->param ('copyright'))
    {
	if (defined $copyright{$page} && length $copyright{$page})
	{
	    $template->param (copyright =>
	      IkiWiki::linkify ($page, $destpage, $copyright{$page}));
	}
    }
    if ($template->query (name => "license") &&
	! defined $template->param ('license'))
    {
	if (defined $license{$page} && length $license{$page})
	{
	    $template->param (license =>
	      IkiWiki::linkify ($page, $destpage, $license{$page}));
	}
    }
}

1
