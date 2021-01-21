#!/bin/bash
#
# Usage:
#
#    init_project_from_template.sh
#
# You need to edit project_settings.sh and fill in some variable values before running it.
#
# This works on Mac and Linux. If you're running Windows, install Ubuntu for Windows and use that!

# Don't change this file!

set -e

source ./project_settings.sh

if [[ ! -e "doc-src-$DOCSITETOOL" ]]; then
  echo >&2 "Error: Invalid choice for DOCSITETOOL: $DOCSITETOOL"
  echo >&2 "Error: Valid values are: jekyll, mkdocs"
  exit 1
fi

# Setup

# Do this instead of ${PACKAGE^}, because that syntax requires bash 4, and macOS
# ships with bash 3.
first=${PACKAGE:0:1}
rest=${PACKAGE:1}
firstcap=$(echo $first | tr 'a-z' 'A-Z')
PACKAGE_CAP="${firstcap}${rest}"

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

echo ""
echo "Initializing project $PROJECT"

if [[ ! -d "doc-src-$DOCSITETOOL" ]]; then
  echo >&2 "Error: invalid choice for DOCSITETOOL: $DOCSITETOOL"
  echo >&2 "Valid choices are: jekyll, mkdocs, gh-pages"
  exit 1
fi

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

# TODO: Validate that summary and description do not contain <, >, or &

# Munge the source code and documentation

mv Mcode/+mypackage/+internal/MypackageBase.m Mcode/+mypackage/+internal/${PACKAGE_CAP}Base.m
mv Mcode/+mypackage/+internal/MypackageBaseHandle.m Mcode/+mypackage/+internal/${PACKAGE_CAP}BaseHandle.m
mv Mcode/+mypackage Mcode/+$PACKAGE
mv src/java/myproject-java/src/main/java/com/example/mypackage \
    src/java/myproject-java/src/main/java/com/example/$PACKAGE
mv src/java/myproject-java src/java/${PROJECT}-java
for f in *mypackage* dev-kit/*mypackage*; do
  mv "$f" "$(echo "$f" | sed s/mypackage/$PACKAGE/)"
done

mv MatlabProjectTemplate/project-README.md README.md
mungefiles=".gitignore Makefile *.md */*.md */*.adoc */*.yml myproject.prj.in *.m */*.m */*/*.m */*/*/*.m src/java/*/*.xml azure-pipelines.yml .travis.yml .circleci/config.yml dev-kit/* CHANGES.txt info.xml doc-project/*.txt doc-project/*.md"
perl -spi -e "s/__myproject__/$PROJECT/g" $mungefiles
perl -spi -e "s/__myprojectemail__/$PROJECT_EMAIL/g" $mungefiles
perl -spi -e "s/__myprojectguid__/$PROJECT_GUID/g" $mungefiles
perl -spi -e "s/__myproject_matlab_version__/$PROJECT_MATLAB_VERSION/g" $mungefiles
perl -spi -e "s/__myghuser__/$GHUSER/g" $mungefiles
perl -spi -e "s/__YOUR_NAME_HERE__/$PROJECT_AUTHOR/g" $mungefiles
perl -spi -e "s/__myproject_summary__/$PROJECT_SUMMARY/g" $mungefiles
perl -spi -e "s/__myproject_description__/$PROJECT_DESCRIPTION/g" $mungefiles
# TODO: This doesn't work because homepage may contain slashes!
#perl -spi -e "s/__author_homepage__/$AUTHOR_HOMEPAGE/g" $mungefiles
perl -spi -e "s/myproject/$PROJECT/g" $mungefiles
perl -spi -e "s/mypackage/$PACKAGE/g" $mungefiles
perl -spi -e "s/myghuser/$GHUSER/g" $mungefiles
perl -spi -e "s/Mypackage/$PACKAGE_CAP/g" $mungefiles
perl -spi -e "s/R2019b/$PROJECT_MATLAB_VERSION/g" myproject.prj.in .matlab_version
perl -spi -e "s/command: .\/MatlabProjectTemplate\/test_project_initialization/command: echo Hello world/g" \
  ./.circleci/config.yml
perl -spi -e "s/- .\/MatlabProjectTemplate\/test_project_initialization//" \
  .travis.yml

rm -rf docs doc/*
cp -R doc-src-$DOCSITETOOL docs
rm -rf doc-src-*

echo $PROJECT_MATLAB_VERSION > .matlab_version
echo "0.1.0" > VERSION
mv myproject.prj.in $PROJECT.prj.in

# Okeedoke!

echo ""
echo "Project $PROJECT is initialized."
echo "See MatlabProjectTemplate/README.md for more info."
echo ""
echo "Happy hacking!"
echo ""

rm ./init_project_from_template.sh
