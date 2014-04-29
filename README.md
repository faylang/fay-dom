fay-dom
=======

A FFI wrapper for DOM functions for use with
[Fay](http://www.fay-lang.org). It includes functions for the more
commonly used DOM features. See
[fay-jquery](https://github.com/faylang/fay-jquery) if you want
wrappers for jQuery.

Usage
-----

Just install it with cabal:

    $ cabal install fay-dom

Then include it at the top of your `file.hs`:

    import DOM

fay-dom uses [fay-text](http://www.github.com/faylang/fay-text) so you probably want to enable `OverloadedStrings` and `RebindableSyntax` when using this package.

Finally, build the javascript including the package, as explained on [the wiki](https://github.com/faylang/fay/wiki/Package-management-with-Cabal):

    $ fay --package fay-text,fay-dom file.hs

Development Status
------------------

Rudimentary at the moment. Functions will be added when people find
the need for them. A lot of what this library could do already exists
in fay-jquery, but if anyone wants to write Fay without jQuery feel
free to add whatever is missing.


Contributions
-------------

Fork on!

Any enhancements are welcome.

The github master might require the latest fay master, available at
[faylang/fay](https://github.com/faylang/fay/).
