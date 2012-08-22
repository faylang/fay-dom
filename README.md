fay-dom
=======

A FFI wrapper for DOM functions for use with
[Fay](http://www.fay-lang.org). It includes functions for the more
commonly used DOM features. See
[fay-jquery](https://github.com/brianhv/fay-jquery) if you want
wrappers for jQuery.

Usage
-----

```
git clone git://github.com/bergmark/fay-dom.git
cd fay-dom
cabal install
```

The library is now installed in your cabal directory and can be seen
in haskell-mode auto-completion and such. To use this with Fay, use the `--include` flag:

```
fay --include=~/.cabal/share/fay-dom-0.1.0.0/src myfile.hs
```

To typecheck `myfile.hs` with ghc, do:

```
ghc ~/.cabal/share/fay-dom-0.1.0.0/src/ myfile.hs
```

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
