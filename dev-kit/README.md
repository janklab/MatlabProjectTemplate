# __myproject__ Dev Kit

This directory contains tools for doing development on __myproject__ itself. It is for use by the developers of __myproject__, and is not for use by users of it, and does not ship with the project distribution.

__myproject__ developers should add this directory to their Matlab path when working on the project.

The whole thing about this directory is that it doesn't care about name collisions in its class and function names; it assumes that __myproject__ is the only thing you're working on in your session. It names functions whatever it wants, and doesn't put them inside packages. (This is intentional, to make it convenient for __myproject__ developers to call them without having to type out the package name all the time.) So it is _not_ suitable for redistribution to users.
