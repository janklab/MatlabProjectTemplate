# MatlabProjectTemplate FAQs and IAQs

## Why does this require Mac or Linux to initialize the project?

Because basic Windows sucks as a programming environment. It doesn't ship with any programming languages powerful enough to do even the basic text processing that basic project initialization requires.

This might change now that Powershell is becoming more widespread.

## Why is there _so much stuff_ in this? It's supposed to be a "basic" template!

Well: Matlab is a great tool, but as a programming language, its software development toolchain is somewhat anemic, and is oriented towards manual, interactive use. So your project has to fill in the gaps.

For example: the Matlab `.prj` file format for generating Matlab Toolbox `.mltbx` files has a design flaw that bakes in _absolute_ paths to your source code in the `.prj` file, which makes it unusable for projects with multiple developers. So we have to add in an additional layer to dynamically generate the `.prj` file from a `.prj.in` file and `package_toolbox`. And the Matlab Compiler and Toolbox builder both require you to have your project on the Matlab path and initialized, so we need to add in a layer of launcher scripts that can do that from the command line.

And half the stuff in here is just about making decent documentation for your project; surely you want that!

## Should I p-code my files?

No. P-coding is a weak obfuscation mechanism and provides no other benefits. It's not strong enough to actually protect your intellectual property for proprietary software, and open source software shouldn't be obfuscated.

But some users are going to want to P-code anyway, so we're providing support for it.

## Why isn't MEX building part of the `make build` or `make dist` step?

Because you should actually check in all your compiled MEX files into your git repo! This makes it so that users can run your project directly from the repo. Users and even developers cannot be expected to have a setup on their machine where they can build the MEX files themselves. This is a different model from most programming languages.

You can use the `dev-kit/buildallmexfiles.m` function to build/rebuild all the MEX files in your source tree.

## So, how can I build cross-platform MEX files to support all OSes?

Hell if I know. You'll probably need to pay for a cloud CI system or set up your own multi-OS build farm.

This is why it's good to avoid MEX files if you can.

## Why do you put unit tests in the main `Mcode/` dir instead of the separate top-level `tests` dir?

Because I think that projects, especially software libraries, should actually ship all their tests with the distribution, so that users can run the tests in their environment and ensure that the software operates correctly in that context. The top-level `tests/` directory just contains wrapper scripts for launching your tests from the main `Mcode/` directory.
