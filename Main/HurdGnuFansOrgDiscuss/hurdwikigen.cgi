#!/usr/bin/python
# This is a crude python script used to cut out the contents of
# a wiki page for use in an ordinary page.
#
# Original version for WikiMoinMoin by <JAkov AT vmlinux DOT org>
# Refined and added caching including conversion to TWiki, but
# still a big hack, by <Joachim AT vmlinux DOT org>
#
# This script can be used freely under the traditional BSD license,
# without the advertising clause.
#


import fileinput
import string
import os
import os.path
from os.path import getmtime, exists
import sys
import cgi
from types import ListType


# Set an appropriate CGI header.
print "Content-type: text/html\r\n\r\n"

##
# Creates a HTML page, filename, from the given URL.
# The HTML is extracted with lynx and parsed for the occurrence of
# the <!-- MESSAGESEPARATOR --> comment tag. All HTML between the
# first and last tag is written to filename.
#
def create_html (filename, url):
        f = open (filename, 'w')
        raw_data = os.popen ('/usr/bin/lynx -source ' + url).read ()
	cooked_data = string.replace (raw_data, "PageTop", "PageBottom")
	raw_data = string.split (cooked_data, "<a name=\"PageBottom\"></a>")
        f.write (raw_data[1])
        f.close ()
	return

form = cgi.FieldStorage ()
web = form.getvalue ("web", "")
page = form.getvalue ("topic", "")
#page = sys.argv[1]

wiki_file = '/home/virtual/gnufans.org/hurd/data/' + web + '/' + page + '.txt'
wiki_url  = 'http://hurd.gnufans.org/bin/view/' + web +'/' + page + '?skin=plain'
html_file = '/home/virtual/gnufans.org/hurd/spool/' + web + "-" + page

#print "<h2Debugging info:</h2>"
#print 'wiki_file="' + wiki_file + '"'
#print 'wiki_url="'  + wiki_url  + '"'
#print 'html_file='  + html_file + '"'


if not exists (wiki_file):
	print "The page " + wiki_url + "does not exist!"
	exit
	
if not exists (html_file):
#	print "Creating html file."
	create_html (html_file, wiki_url)
else:
#	print "Reading file modification times."
	wiki_file_time = getmtime (wiki_file)
	html_file_time = getmtime (html_file)
	
#	print wiki_file_time
#	print html_file_time

	if wiki_file_time > html_file_time:
#		print "Wiki file newer than html file."
		create_html (html_file, wiki_url)

# Print contents of spool file to stdout
document = open (html_file, 'r')
content  = document.read ()

print content

