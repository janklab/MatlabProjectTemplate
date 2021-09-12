---
layout: default
---

# __myproject__ Documentation

__myproject_summary__

## About

__myproject_description__

## Installation

## Usage

### Examples

```matlab
classdef SomeClass < SomeOtherClass

  properties
    x (1,1) double = 42
    y
  end

  methods
    function this = SomeClass()
    end
  end

end

function anExampleFunction(foo, bar, baz, qux)
  arguments
    foo
    bar (1,1) double
    baz string = "whatever"
    qux string = "foo" {mustBeMember(qux, ["foo" "bar" "baz"])}
  end

  fprintf('Hello, world!\n')
end
```

## AsciiDoc

Some of the documentation pages use AsciiDoc. See [here](Use-AsciiDoc/index.html) for an example.

## Author

__myproject__ is written and maintained by [__YOUR_NAME_HERE__](__author_homepage__). The project home page is <https://github.com/__myghuser__/__myproject__>.

## Acknowledgments

This project was created with [MatlabProjectTemplate](https://github.com/apjanke/MatlabProjectTemplate) by [Andrew Janke](https://apjanke.net).
