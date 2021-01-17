# MatlabProjectTemplate

This is a template repo for creating Matlab library and application projects. It defines a "standard" project structure that should be suitable for many projects, including those intended for redistribution / open source.

It is suitable for both libraries and applications, and includes coding and organizational conventions that make it safe to use this project's code in a Matlab environment that uses code from other projects, too.

## MatlabProjectTemplate Template Usage

To create a new project from this template, go on GitHub, create a new repo, and select this repo as its template.

Then:

* Add a license file!
* Edit the variables `project_settings.sh`
* Run `init_project_from_template.sh`
* Edit `.editorconfig` to reflect your preferred code style
* Edit `<myproject>.prj.in` and put in all your contact and descriptive info and other stuff
* Edit the files in `doc-project` to reflect your plans
* Put your main Matlab source code in `Mcode/`
* Put your example scripts in `examples/`
* Hack away!

See `MatlabProjectTemplate/README.md` and other documents in the `MatlabProjectTemplate/` directory for more information and details.

## Unit tests

You should write unit tests for your project! Use the [Matlab Unit Test Framework](https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html) and put your tests in `Mcode/+<myproject>/+test`. Run them with `make test`.

## About MatlabProjectTemplate

MatlabProjectTemplate was written by [Andrew Janke](https://apjanke.net). The project home page is <https://github.com/janklab/MatlabProjectTemplate>. You can get support, or even contribute to the project, there.

See the [FAQ](https://github.com/janklab/MatlabProjectTemplate/MatlabProjectTemplate/doc/FAQ.html) or the stuff in the `MatlabProjectTemplate/doc` directory for more info.

## That's all folks

Info about your own project starts here!

----------------------------------------------------------------------------
# __myproject__

## About

Describe your project!

## Installation

## Usage

### Examples

## Author

__myproject__ is written and maintained by [YOUR-NAME-HERE](https://your-website.com). The project home page is <https://github.com/__myghuser__/__myproject__>.

## Acknowledgments

This project was created with [MatlabProjectTemplate](https://github.com/apjanke/MatlabProjectTemplate) by [Andrew Janke](https://apjanke.net).
