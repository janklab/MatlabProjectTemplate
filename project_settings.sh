# Edit these variables to for your project
#
# This file is only used during project initialization. You can throw it away after
# that, but I'd keep it around anyway, just in case.

# The name of your project and its GitHub repo. Capitalization should match what
# your public "branding" is; this will show up in human-readable documentation.
PROJECT=MyCoolProject

# The version of Matlab you're developing against. This will be the version of
# Matlab that the project builds against (on Mac and Windows anyway), and the minimum
# required version declared in the project Toolbox file.
PROJECT_MATLAB_VERSION=R2019b

# The name of the top-level Matlab package that your project defines and keeps
# its code in. This is the "+<package>" directory that'll be directly under Mcode,
# and is the "namespace" that your project lives in.
# It is conventional for package names to be in all lower case.
PACKAGE=mycoolpackage

# Your GitHub user name or organization name that's hosting the project
GHUSER=mygithubusername

# If you want to provide a contact email for your project, put it here. Optional.
PROJECT_EMAIL=

# The site generator tool you want to use for the project documentation.
# Valid choices are:
#   "jekyll"   - Jeyll for building local docs
#   "mkdocs"   - mkdocs for building local docs
#   "gh-pages" - Jekyll for both GitHub Pages hosting and local docs
# If you have a large project, you should stick with "jekyll" or "mkdocs" and put your
# main GitHub Pages website in a separate repo.
DOCSITETOOL=jekyll

# Human-readable name of the project's primary author or maintainer
PROJECT_AUTHOR="Your Name Here"

# Everything below here is optional! If you omit it, you'll end up with placeholder text
# in some of your documentation, but the project will still work

# One-sentence summary of the project. No <, >, /, or & characters allowed!
PROJECT_SUMMARY="Short summary of project goes here"

# Multi-sentence project description. No <, >, /, or & characters allowed!
PROJECT_DESCRIPTION="Longer description of project goes here."

# Home page web site for the project's author
AUTHOR_HOMEPAGE="https://github.com/$GHUSER"
