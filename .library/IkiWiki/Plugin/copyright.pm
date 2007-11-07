# A plugin for ikiwiki to implement adding a footer with copyright information
# based on a default value taken out of a file.

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

# A footer with copyright information will be added to every rendered page if
# (a) such a footer isn't present already (see the `meta' plugin's
# ``copyright'' facility) and (b) a file `copyright.html' is found (using the
# same rules as for the sidebar plugin).
#
# The state which page's copyright text was gathered from which source is not
# tracked, so you'll need a full wiki-rebuild if (b)'s files are changed.
#
# You can use wiki links in `copyright.html'.

package IkiWiki::Plugin::copyright;

use warnings;
use strict;
use IkiWiki 2.00;

sub import
{
    hook (type => "pagetemplate", id => "copyright", call => \&pagetemplate,
	  # Run last, as to have the `meta' plugin do its work first.
	  last => 1);
}

sub pagetemplate (@)
{
    my %params = @_;
    my $page = $params{page};
    my $destpage = $params{destpage};

    my $template = $params{template};

    if ($template->query (name => "copyright") &&
	! defined $template->param ('copyright'))
    {
	my $content;
	my $copyright_page = bestlink ($page, "copyright") || return;
	my $copyright_file = $pagesources{$copyright_page} || return;
	#my $pagetype = pagetype ($copyright_file);
	# Check if ``$pagetype eq 'html'''?
	$content = readfile (srcfile ($copyright_file));

	if (defined $content && length $content)
	{
	    $template->param (copyright =>
	      IkiWiki::linkify ($page, $destpage, $content));
	}
    }
}

1
