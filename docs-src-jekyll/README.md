# docs-src

This directory contains stuff for generating the project documentation using Jekyll, a static site generator that uses Markdown.

## Requirements

You will need to have Ruby and Bundler installed on your machine. This part you'll have to figure out yourself.

Then do "bundle install" in this directory before it will work.

## Usage

Get set up:

```bash
bundle install
```

Preview the site in a local web server:

```bash
bundle exec jekyll serve
```

To actually build the documentation for use in your project's distribution, go back up a directory and run `make doc`.

## Writing documentation

You can use either Markdown or AsciiDoc to write your documentation files. Markdown files must have a `.md` extension. Asciidoc files must have `.adoc` or another standard AsciiDoc file extension. See `Use-AsciiDoc.adoc` for examples.
