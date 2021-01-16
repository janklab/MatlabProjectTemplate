# MatlabProjectTemplate

This is a template repo for creating Matlab library and application projects. It defines a "standard" project structure that should be suitable for many projects, including those intended for redistribution / open source.

It is suitable for both libraries and applications, and includes coding and organizational conventions that make it safe to use this project's code in a Matlab environment that uses code from other projects, too.

## MatlabProjectTemplate Template Usage

To create a new project from this template, go on GitHub, create a new repo, and select this repo as its template.

Then:

* Add a license file!
* Edit the variables at the top of `init_project_from_template.sh` and then run it
* Put your main Matlab source code in `Mcode/`
* Put your example scripts in `examples/`
* Edit `.editorconfig` to reflect your preferred code style
* Edit the files in `doc-project` to reflect your plans
* Choose a document format: Jekyll, Asciidoc, or mkdocs. Move the appropriate `doc-src-<type>` to `doc-src` and delete the others.

Info about your own project starts here!

----------------------------------------------------------------------------
# <myproject>

## About

Describe your project!

## Installation

## Usage

### Examples

## Author

<myproject> is written and maintained by [YOUR-NAME-HERE](https://your-website.com). The project home page is <https://github.com/<user>/<myproject>>.

## Acknowledgments

This project was created with [MatlabProjectTemplate](https://github.com/apjanke/MatlabProjectTemplate) by [Andrew Janke](https://apjanke.net).
