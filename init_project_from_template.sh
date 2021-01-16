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

# If you want to provide a contact email for your project, put it here. Optional.
PROJECT_EMAIL=

# The site generator tool you want to use for the project documentation.
# Valid choices are "jekyll", "asciidoc", and "mkdocs"


# Don't touch anything below here!

if [[ ! -e "doc-src-$DOCTOOL" ]]; then
  echo >&2 "Error: Invalid choice for DOCTOOL: $DOCTOOL"
  echo >&2 "Error: Valid values are: jekyll, asciidoc, mkdocs"
  exit 1
fi

# Munge the source code and documentation

perl -spi -e "s/mypackage/$PACKAGE" */*.m
mv Mcode/+mypackage Mcode/+$PACKAGE

docfiles="*.md */*.md doc-src*/*.yml"
perl -spi -e "s/__myproject__/$PROJECT" $docfiles 
perl -spi -e "s/__myprojectemail__/$PROJECT_EMAIL" $docfiles
perl -spi -e "s/__myghuser__/$GHUSER/g" $docfiles

mv doc-src-$DOCTOOL doc-src

# Clean up the README

perl -spi -e 's/.*--------------//mg' README.md

# Okeedoke!

echo "Project $PROJECT is initialized."
echo "See MatlabProjectTemplate/README.md for more info."
echo ""
echo "Happy hacking!"

