# Copyright © 2010 Thomas Schwinge <thomas@schwinge.name>

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

package IkiWiki::Plugin::reset_mtimes;

use warnings;
use strict;
use IkiWiki 3.00;

# This plugin resets pages' / files' mtimes according to the RCS information
# when using --refresh mode.
# 
# Note that the files' mtimes are *always* set, even if the file has
# un-committed changes.
# 
# <http://ikiwiki.info/bugs/pagemtime_in_refresh_mode/>

sub import
{
    hook (type => "needsbuild",
	  id => "reset_mtimes",
	  call => \&needsbuild);
}

sub needsbuild (@)
{
    # Only proceed if --gettime is in effect, as we're clearly not intersted in
    # this functionality otherwise.
    return unless $config{gettime};

    my $files = shift;
    foreach my $file (@$files)
    {
	# [TODO.  Perhaps not necessary.  Can this hook ever be called for
	# removed pages -- that need to be ``rebuilt'' in the sense that
	# they're to be removed?]  Don't bother for pages that don't exist
	# anymore.
	next unless -e "$config{srcdir}/$file";

	my $page = pagename ($file);
	debug ("needsbuild: <$file> <$page>");

	# Only ever update -- otherwise ikiwiki shall do its own thing.
	if (defined $IkiWiki::pagemtime{$page})
	{
	    debug ("pagemtime: " . $IkiWiki::pagemtime{$page});

	    my $mtime = 0;
	    eval
	    {
		$mtime = IkiWiki::rcs_getmtime ($file);
	    };
	    if ($@)
	    {
		print STDERR $@;
	    }
	    elsif ($mtime > 0)
	    {
		$IkiWiki::pagemtime{$page} = $mtime;

		# We have to set the actual file's mtime too, as otherwise
		# ikiwiki will update it again and again.
		utime($mtime, $mtime, "$config{srcdir}/$file");
	    }

	    debug ("pagemtime: " . $IkiWiki::pagemtime{$page});
	}
    }
}

1
