# MatlabProjectTemplate

[![Travis Build Status](https://travis-ci.com/janklab/MatlabProjectTemplate.svg?branch=main)](https://travis-ci.com/github/janklab/MatlabProjectTemplate)  [![CircleCI Build Status](https://circleci.com/gh/janklab/MatlabProjectTemplate.svg?style=shield)](https://circleci.com/gh/janklab/MatlabProjectTemplate) [![Azure Build Status](https://dev.azure.com/janklab/MatlabProjectTemplate/_apis/build/status/janklab.MatlabProjectTemplate?branchName=main)](https://dev.azure.com/janklab/MatlabProjectTemplate/_build/latest?definitionId=1&branchName=main) [![View MatlabProjectTemplate on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/85840-matlabprojecttemplate)

MatlabProjectTemplate ("MPT") is a template repo for creating Matlab library and application projects. It defines a "standard" project structure that should be suitable for many projects, including those intended for redistribution / open source.

It is suitable for both libraries and applications, and includes coding and organizational conventions that make it safe to use this project's code in a Matlab environment that uses code from other projects, too.

## Features

MatlabProjectTemplate supports the following features. You don't _have_ to use any of them; you can just ignore the ones you don't care about. But they're there if you need them! MPT's philosophy is "support but do not require".

* Collaboration between multiple developers
* Building [Matlab Toolboxes](https://www.mathworks.com/help/matlab/matlab_prog/create-and-share-custom-matlab-toolboxes.html)
* Matlab [Continuous Integration](https://www.mathworks.com/solutions/continuous-integration.html) and unit tests
* Distribution as both plain zip files and Matlab Toolbox `.mltbx` files
* Using ("vendoring") third-party Java JAR and Matlab libraries
* Custom Java code
* Library initialization
* [_Automatic_](https://matlabprojecttemplate.janklab.net/AutoInitialization.html) library initialization
* Logging, in an [SLF4M](https://github.com/janklab/SLF4M)/SLF4J/Log4j-compatible manner

## Requirements

Just Matlab, for most things.

Building custom Java code requires Mac or Linux plus a Java JDK and Apache Maven. If you're a Java developer, you know how to set theseup.

## Usage

To create a new project from this template, go to [its repo on GitHub](https://github.com/janklab/MatlabProjectTemplate) and create a new repo by clicking the green "Use this template" button.

NOTE: Don't "fork" or "clone" the MatlabProjectTemplate repo. That will leave your project's Git repo set up wrong! Do the "Use this template" thing.

Then:

* Add a license file!
* Edit the variables `project_settings.m`.
* Open Matlab and run `init_project_from_template.m`.
* Edit `.editorconfig` to reflect your preferred code style.
* Edit `<myproject>.prj.in` and put in all your contact and descriptive info and other stuff.

And then:

* Put your main Matlab source code in `Mcode/`.
* Put your example scripts in `examples/`.
* Edit the files in `doc-project` to reflect your plans.
* Hack away!

When you're developing code for your project, you should add the `dev-kit/` directory to your Matlab path.

See the [User Guide](https://matlabprojecttemplate.janklab.net/UserGuide.html) for more information.

## Unit tests

You should write unit tests for your project! Use the [Matlab Unit Test Framework](https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html) and put your tests in `Mcode/+<myproject>/+test`. Run them with `make test` in the shell or with `dev-kit/launchtests.m` in Matlab.

## License

MatlabProjectTemplate is multi-licensed under all of: BSD 3-Clause License, BSD 2-Clause License, Apache License, MIT License, and GPLv3. You can use it in any project with a license compatible with any of those licenses. This includes commercial and proprietary software, and contemporary postings to MathWorks File Exchange.

If you have a licensing scenario which is not covered by the above (and jeez, what are you doing that would require _that_?), just contact me, and I'll probably add support for it. My intention is that _everybody_ can use MatlabProjectTemplate.

## About MatlabProjectTemplate

MatlabProjectTemplate was written by [Andrew Janke](https://apjanke.net).

You can read the online documentation on the [project website](https://matlabprojecttemplate.janklab.net) and or find the code and get support at the [repo on GitHub](https://github.com/janklab/MatlabProjectTemplate). Bug reports, feature requests, and other feedback are welcome.

See the [FAQ](https://matlabprojecttemplate.janklab.net/FAQ.md) or the stuff in the `MatlabProjectTemplate/doc` directory for more info.
