#!/bin/bash
#
# Usage:
#
#    init_project_from_template.sh
#
# You need to edit project_settings.sh and fill in some variable values before running it.
#
# This works on Mac and Linux.

# Don't touch anything below here!

source ./project_settings.sh

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

perl -spi -e "s/mypackage/$PACKAGE/g" *.m */*.m */*/*.m src/java/*/*.xml
mv Mcode/+mypackage Mcode/+$PACKAGE
mv src/java/myproject-java/src/main/java/com/example/mypackage \
    src/java/myproject-java/src/main/java/com/example/$PACKAGE
mv src/java/myproject-java src/java/${PROJECT}-java

mungefiles="Makefile *.md */*.md */*.adoc */*.yml myproject.prj.in */*/*.m *.m src/java/*/*.xml"
perl -spi -e "s/__myproject__/$PROJECT/g" $mungefiles
perl -spi -e "s/myproject/$PROJECT/g" $mungefiles
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
