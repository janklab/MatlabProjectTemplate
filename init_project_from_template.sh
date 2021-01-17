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

# The version of Matlab you're developing against. This will be the version of
# Matlab that the project builds against (on Mac and Windows anyway), and the minimum
# required version declared in the project Toolbox file.
PROJECT_MATLAB_VERSION=R2019b

# The name of the top-level Matlab package that your project defines and keeps
# its code in. This is the "+<package>" directory that'll be directly under Mcode,
# and is the "namespace" that your project lives in.
PACKAGE=mycoolpackage

# Your GitHub user name or organization name that's hosting the project
GHUSER=mygithubusername

# If you want to provide a contact email for your project, put it here. Optional.
PROJECT_EMAIL=

# The site generator tool you want to use for the project documentation.
# Valid choices are "jekyll" and  "mkdocs"
DOCSITETOOL=jekyll

# Don't touch anything below here!

if [[ ! -e "doc-src-$DOCSITETOOL" ]]; then
  echo >&2 "Error: Invalid choice for DOCSITETOOL: $DOCSITETOOL"
  echo >&2 "Error: Valid values are: jekyll, mkdocs"
  exit 1
fi

# Set up prerequisites

function locate-matlab-on-mac() {
  if ! which matlab &> /dev/null; then
    # Prefer newer versions
    want_matlab_rels=(R2022a R2021b R2021a R2020b R2020a R2019b R2019a R2018b R2018a R2017b R2017a)
    # I actually am specifically on R2019b now
    want_matlab_rels=($PROJECT_MATLAB_VERSION $want_matlab_rels)
    for matlab_rel in "${want_matlab_rels[@]}"; do
      matlab_app="/Applications/MATLAB_${matlab_rel}.app"
      if [[ -f "$matlab_app/bin/matlab" ]]; then
        PATH="$PATH:$matlab_app/bin"
        break
      fi
    done
  fi
}

uname=$(uname)
if [[ $uname == "Darwin" ]]; then
  locate-matlab-on-mac
  if ! which matlab &> /dev/null; then
    echo &>2 "Error: could not locate matlab. Please check that it is installed."
    exit 1
  fi
fi

echo ""
echo "Generating a GUID for your project's Toolbox..."
PROJECT_GUID=$(matlab -batch 'fprintf("%s", char(toString(java.util.UUID.randomUUID)))')
if [[ $? != 0 ]]; then 
  echo >&2 "Error: Failed generating a GUID using Matlab."
  exit 1
fi

# Munge the source code and documentation

perl -spi -e "s/mypackage/$PACKAGE/g" *.m */*.m */*/*.m
mv Mcode/+mypackage Mcode/+$PACKAGE

mungefiles="*.md */*.md */*.adoc */*.yml myproject.prj.in */*/*.m *.m"
perl -spi -e "s/__myproject__/$PROJECT/g" $mungefiles
perl -spi -e "s/__myprojectemail__/$PROJECT_EMAIL/g" $mungefiles
perl -spi -e "s/__myprojectguid__/$PROJECT_GUID/g" $mungefiles
perl -spi -e "s/__myproject_matlab_version__/$PROJECT_MATLAB_VERSION/g" $mungefiles
perl -spi -e "s/__myghuser__/$GHUSER/g" $mungefiles

cp -R doc-src-$DOCSITETOOL doc-src
rm -rf doc-src-*

echo $PROJECT_MATLAB_VERSION > .matlab_version
mv myproject.prj.in $PROJECT.prj.in

# Clean up the README

perl -0pi -e 's/.*--------------\n//smg' README.md

# Okeedoke!

echo ""
echo "Project $PROJECT is initialized."
echo "See MatlabProjectTemplate/README.md for more info."
echo ""
echo "Happy hacking!"
echo ""
