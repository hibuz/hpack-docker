#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os

#print len(sys.argv)
#print sys.argv

if len(sys.argv) < 4:
	print "Usage:", sys.argv[0], "<ProjectName> <SourceFile> <DestinationFile>"
	sys.exit(1)

prj_svn = os.environ['HPACK_PRJ_SVN']
prj_git = os.environ['HPACK_PRJ_GIT']
template = os.environ['HPACK_TEMPLATE']
prj_name = sys.argv[1]
src_file = sys.argv[2]
dest_file = sys.argv[3]

#print project_name
#print src_file
#print dest_file

f = open(src_file, "rt")
f2 = open(dest_file, "wt")

while f:
        line = f.readline()
        rep_line = line.replace("%PROJECT_NAME%", prj_name)
        rep_line = rep_line.replace("%HPACK_PRJ_SVN%", prj_svn)
        rep_line = rep_line.replace("%HPACK_PRJ_GIT%", prj_git)
        rep_line = rep_line.replace("%HPACK_TEMPLATE%", template)
        if len(line) == 0:
                break
        f2.write(rep_line)

f.close()
f2.close()

print "replaced and copied."

