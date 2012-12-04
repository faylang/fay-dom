{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Language.Fay.DOM where

import           Language.Fay.FFI
import           Language.Fay.Prelude


-- | Foreign Data Declarations.

data Document
instance Foreign Document
data Element
instance Foreign Element
data Event
instance Foreign Event
data Global
instance Foreign Global
data NodeList
instance Foreign NodeList
data Timer
instance Foreign Timer
data XMLHttpRequest
instance Foreign XMLHttpRequest



-- | Browser globals

getWindow :: Fay Global
getWindow = ffi "window"

getDocument :: Fay Document
getDocument = ffi "window.document"

addEvent :: Foreign f => String -> Fay f -> Fay ()
addEvent = ffi "window['addEventListener'](%1,%2)"


-- | Events

stopProp :: Event -> Fay ()
stopProp = ffi "%1['stopPropagation']()"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1['preventDefault']()"


-- | Element accessors

createElement :: String -> Fay Element
createElement = ffi "window['document']['createElement'](%1)"

appendChild :: Element -> Element -> Fay ()
appendChild = ffi "%1.appendChild(%2)"

removeChild :: Element -> Element -> Fay ()
removeChild = ffi "%1.removeChild(%2)"

parentNode :: Element -> Fay Element
parentNode = ffi "%1.parentNode"

children :: Element -> Fay NodeList
children = ffi "%1.children"


-- | Logging

logS :: String -> Fay ()
logS = ffi "console['log'](%1)"

log :: Foreign f => f -> Fay ()
log = ffi "console['log'](%1)"


-- | Timers

-- | setInterval except the calling function gets the timer as an
-- | argument so the interval can be cancelled from within it.
setInterval :: Double -> (Timer -> Fay ()) -> Fay Timer
setInterval = ffi "(function (f,i) { var id = window['setInterval'](function () { f(id); }, i); })(%2,%1)"

clearInterval :: Timer -> Fay ()
clearInterval = ffi "window['clearInterval'](%1)"

setTimeout :: Double -> (Timer -> Fay ()) -> Fay Timer
setTimeout = ffi "window['setTimeout'](%1)"

-- | XMLHttpRequest

data RequestMethod = GET | POST | PUT | HEAD
instance Foreign RequestMethod

data ReadyState = UNSENT | OPENED | HEADERS_RECEIVED | LOADING | DONE
instance Foreign ReadyState

xmlHttpRequest :: Fay XMLHttpRequest
xmlHttpRequest = ffi "(function(window) { if(window['XMLHttpRequest']) return new XMLHttpRequest(); else return new ActiveXObject('Microsoft.XMLHTTP'); })(window)"

open :: RequestMethod -> String -> XMLHttpRequest -> Fay XMLHttpRequest
open = ffi "(function(method, url, xhr) { xhr['open'](method['instance'], url, true); return xhr; })(%1, %2, %3)"

send :: XMLHttpRequest -> Fay ()
send = ffi "%1['send']()"

setReadyStateHandler :: (XMLHttpRequest -> Fay ()) -> XMLHttpRequest -> Fay XMLHttpRequest
setReadyStateHandler = ffi "(function(handler, xhr) { xhr['onreadystatechange'] = function() { handler(xhr); }; return xhr; })(%1, %2)"

readyState :: XMLHttpRequest -> Fay ReadyState
readyState = ffi "{ instance: ['UNSENT', 'OPENED', 'HEADERS_RECEIVED', 'LOADING', 'DONE'][%1['readyState']] }"

responseText :: XMLHttpRequest -> Fay String
responseText = ffi "%1['responseText']"

status :: XMLHttpRequest -> Fay Int
status = ffi "%1['status']"
