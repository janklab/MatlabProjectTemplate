#!/bin/bash
#
# Usage:
#
#    init_project_from_template.sh
#
# You need to edit this file and fill in some variable values before running it.
#
# This works on Mac and Linux.

# Edit these variables to have the right values and then run this script

# The name of your project and its GitHub repo. Capitalization should match what
# your public "branding" is; this will show up in human-readable documentation.
PROJECT=MyProject

# The name of the top-level Matlab package that your project defines and keeps
# its code in. This is the "+<package>" directory that'll be directly under Mcode,
# and is the "namespace" that your project lives in.
PACKAGE=mypackage

# Your GitHub user name or organization name that's hosting the project
GHUSER=mygithubusername



# Don't touch anything below here!

# Munge the source code and documentation

perl -spi -e "s/<myproject>/$PROJECT" *.md */*.md
perl -spi -e "s/mypackage/$PACKAGE" */*.m
perl -spi -e "s/<user>/$GHUSER/g" *.md */*.md

mv Mcode/+mypackage Mcode/+$PACKAGE

# Clean up the README

perl -spi -e 's/.*--------------//mg' README.md

# Remove files used only by the MatlabProjectTemplate repo template

rm -rf makedummies doc-MatlabProjectTemplate

# Okeedoke!

echo "Project $PROJECT is initialized. Happy hacking!"
