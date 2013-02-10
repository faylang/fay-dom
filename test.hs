-- Compile with: fay --html-wrapper test.hs --package fay-dom -p
import Prelude
import DOM

main = do
  putStrLn "Hai"
  setTimeout 200 $ \t -> putStrLn "Hello, World!"
  putStrLn "Bah"
