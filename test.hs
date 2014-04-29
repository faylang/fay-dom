-- Compile with: fay --html-wrapper test.hs --package fay-dom -p
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}

import Prelude (print, (>>), fromInteger, return, ($))
import DOM
import Fay.Text

main = do
  print "Hai"
  setTimeout 200 $ \t -> print "Hello, World!"
  print "Bah"
