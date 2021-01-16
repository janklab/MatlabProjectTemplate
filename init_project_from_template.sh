#!/bin/bash
#
# Usage:
#    init_project_from_template.sh <github_username> <projectname> <projectpackage>
#
# This works on Mac and Linux.

# TODO: Automatic license selection and creation

user=$1
project=$2
package=$3

if [[ -z "$user" || -z "$project" || -z "$package" ]]; then
  echo >&2 "Usage: $0 <github_username> <projectname> <projectpackage>"
  exit 1
fi

perl -spi -e "s/<user>/$user/g" *.md */*.md
perl -spi -e "s/<myproject>/$project" *.md */*.md

mv Mcode/mypackage Mcode/$package

# Remove files used only by the repo template
rm -rf makedummies doc-MatlabProjectTemplate

echo "Project $project is initialized. Happy hacking!"
