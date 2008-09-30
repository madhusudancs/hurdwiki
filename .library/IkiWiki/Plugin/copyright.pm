# A plugin for ikiwiki to implement adding a footer with copyright information
# based on a default value taken out of a file.

# Copyright © 2007, 2008 Thomas Schwinge <tschwinge@gnu.org>
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

# Unless overridden with the `meta' plugin, a footer with copyright information
# will be added to every page using a source file `copyright' (e.g.,
# `copyright.mdwn') (using the same ``locating rules'' as for the sidebar
# plugin).
#
# The state which page's copyright text was gathered from which source is not
# tracked, so you'll need a full wiki-rebuild if the `copyright' file is
# changed.

package IkiWiki::Plugin::copyright;

use warnings;
use strict;
use IkiWiki 2.00;

my %copyright;

sub import
{
    hook (type => "scan", id => "copyright", call => \&scan);
}

sub scan (@)
{
    my %params = @_;
    my $page = $params{page};

    return if defined $pagestate{$page}{meta}{copyright};

    my $content;
    my $copyright_page = bestlink ($page, "copyright") || return;
    my $copyright_file = $pagesources{$copyright_page} || return;

    # Only an optimization to avoid reading the same file again and again.
    $copyright{$copyright_file} = readfile (srcfile ($copyright_file))
	unless defined $copyright{$copyright_file};

    $pagestate{$page}{meta}{copyright} = $copyright{$copyright_file};
}

1
