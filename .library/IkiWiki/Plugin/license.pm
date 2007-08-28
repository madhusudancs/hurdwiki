# A plugin for ikiwiki to implement adding a footer with licensing information
# to every rendered page.

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

# A footer with licensing information will be added to every rendered page if
# either (a) a file `license.mdwn' is found (using the same rules as for the
# sidebar plugin) or (b) (which be used to override (a)) a statement à la
# ``[[license text=WHATEVER]]'' is found in the source page.
#
# The state which page's license text was gathered from which source is not
# tracked, so you'll need a full wiki-rebuild if (a)'s files are changed.

package IkiWiki::Plugin::license;

use warnings;
use strict;
use IkiWiki 2.00;

sub import
{
    hook (type => "preprocess", id => "license", call => \&preprocess);
    hook (type => "pagetemplate", id => "license", call => \&pagetemplate);
}

my %text;

sub preprocess (@)
{
    my %params = @_;
    my $page = $params {page};

    # We don't return any text here, but record the passed text.
    $text {$page} = $params {text};
    return "";
}

sub pagetemplate (@)
{
    my %params = @_;
    my $page = $params {page};
    my $destpage = $params {destpage};

    my $template = $params {template};

    if ($template->query (name => "license"))
    {
	my $content;
	my $pagetype;
	if (defined $text {$page})
	{
	    $pagetype = pagetype ($pagesources {$page});
	    $content = $text {$page};
	}
	else
	{
	    my $license_page = bestlink ($page, "license") || return;
	    my $license_file = $pagesources {$license_page} || return;
	    $pagetype = pagetype ($license_file);
	    $content = readfile (srcfile ($license_file));
	}

	if (defined $content && length $content)
	{
	    $template->param (license =>
	      IkiWiki::htmlize ($destpage, $pagetype,
		IkiWiki::linkify ($page, $destpage,
		  IkiWiki::preprocess ($page, $destpage,
		    IkiWiki::filter ($page, $destpage, $content)))));

	}
    }
}

1
