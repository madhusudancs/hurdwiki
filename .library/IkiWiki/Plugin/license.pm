# A plugin for ikiwiki to implement adding a footer with licensing information
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

# Unless overridden with the `meta' plugin, a footer with licensing information
# will be added to every page using a source file `license' (e.g.,
# `license.mdwn') (using the same ``locating rules'' as for the sidebar
# plugin).
#
# The state which page's license text was gathered from which source is not
# tracked, so you'll need a full wiki-rebuild if the `license' file is changed.

package IkiWiki::Plugin::license;

use warnings;
use strict;
use IkiWiki 2.00;

my %license;

sub import
{
    hook (type => "scan", id => "license", call => \&scan);
}

sub scan (@)
{
    my %params = @_;
    my $page = $params{page};

    return if defined $pagestate{$page}{meta}{license};

    my $content;
    my $license_page = bestlink ($page, "license") || return;
    my $license_file = $pagesources{$license_page} || return;

    # Only an optimization to avoid reading the same file again and again.
    $license{$license_file} = readfile (srcfile ($license_file))
	unless defined $license{$license_file};

    $pagestate{$page}{meta}{license} = $license{$license_file};
}

1
