{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Language.Fay.DOM where

import           Language.Fay.FFI
import           Language.Fay.Prelude

-- | Foreign Data Declarations.
data Element
instance Foreign Element
data Event
instance Foreign Event
data Global
instance Foreign Global
data Document
instance Foreign Document
data Timer
instance Foreign Timer

getWindow :: Fay Global
getWindow = ffi "window"

getDocument :: Fay Document
getDocument = ffi "window.document"

addOnload :: Foreign f => Fay f -> Fay ()
addOnload = ffi "window['addEventListener'](\"load\", %1)"

stopProp :: Event -> Fay ()
stopProp = ffi "%1['stopPropagation']()"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1['preventDefault']()"

createElement :: String -> Fay Element
createElement = ffi "window['document']['createElement'](%1)"

printS :: String -> Fay ()
printS = ffi "console['log'](%1)"

print :: Foreign f => f -> Fay ()
print = ffi "console['log'](%1)"

-- | setInterval except the calling function gets the timer as an
-- | argument so the interval can be cancelled from within it.
setInterval :: Double -> (Timer -> Fay ()) -> Fay Timer
setInterval = ffi "(function (f,i) { var id = window['setInterval'](function () { f(id); }, i); })(%2,%1)"

clearInterval :: Timer -> Fay ()
clearInterval = ffi "window['clearInterval'](%1)"
