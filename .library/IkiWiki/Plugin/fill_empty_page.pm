# A plugin for ikiwiki to implement filling newly created pages from a template
# file.

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

# Newly created pages will be filled from a file `empty_page.mdwn' if such a
# file can be found by using the same rules as for the sidebar plugin.
#
# <http://ikiwiki.info/todo/default_content_for_new_post/>

package IkiWiki::Plugin::fill_empty_page;

use warnings;
use strict;
use IkiWiki 2.00;

sub import
{
    hook (type => "formbuilder_setup", id => "fill_empty_page",
	  call => \&formbuilder_setup);
}

sub formbuilder_setup
{
    my %params = @_;
    my $form = $params{form};
    my $page = $form->field ("page");

    return if $form->title ne "editpage";
    return if $form->field("do") ne "create";

    return if defined $form->field ("editcontent");

    # This is obviously not the last conclusion of wisdom.
    my $empty_page_page = bestlink ($page, "empty_page") || return;
    my $empty_page_file = $pagesources{$empty_page_page} || return;
    my $empty_page_type = pagetype ($empty_page_file);
    return unless defined $empty_page_type;

    my $content = readfile (srcfile ($empty_page_file));

    if (defined $content && length $content)
    {
	$form->field (name => "editcontent", value => $content);

	$form->tmpl_param ("page_preview", "Filled automagically from `"
			   . $empty_page_file . "`.");
    }
}

1
