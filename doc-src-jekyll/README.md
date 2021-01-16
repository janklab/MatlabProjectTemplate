# doc-src

This directory contains stuff for generating the project documentation using Jekyll, a static site generator that uses Markdown.

You will need to have Ruby and Bundler installed on your machine, and do "bundle install" in this directory before it will work.

## Usage

```bash
bundle install
bundle exec jekyll serve
```

To actually build the documentation for use in your project's distribution, go back up a directory and run `make doc`.
