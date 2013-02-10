{-# LANGUAGE EmptyDataDecls    #-}

-- | Document object model functions. Most of this doesn't have
-- anything to do with the DOM and is actually ECMA library stuff, but
-- I'll leave it in for now.

module DOM where

import FFI
import Prelude

--------------------------------------------------------------------------------
-- Foreign Data Declarations.

data Document
data Element
data Event
data Global
data NodeList
data Timer
data XMLHttpRequest

--------------------------------------------------------------------------------
-- Browser globals

getWindow :: Fay Global
getWindow = ffi "window"

getDocument :: Fay Document
getDocument = ffi "window.document"

addEvent :: String -> Fay f -> Fay ()
addEvent = ffi "window['addEventListener'](%1,%2)"

--------------------------------------------------------------------------------
-- Events.

stopProp :: Event -> Fay ()
stopProp = ffi "%1['stopPropagation']()"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1['preventDefault']()"

--------------------------------------------------------------------------------
-- Element accessors.

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

--------------------------------------------------------------------------------
-- Timers

-- | setInterval except the calling function gets the timer as an
-- | argument so the interval can be cancelled from within it.
setInterval :: Double -> (Timer -> Fay ()) -> Fay Timer
setInterval = ffi "(function (f,i) { var id = window['setInterval'](function () { f(id); }, i); })(%2,%1)"

clearInterval :: Timer -> Fay ()
clearInterval = ffi "window['clearInterval'](%1)"

setTimeout :: Double -> (Timer -> Fay ()) -> Fay Timer
setTimeout = ffi "window['setTimeout'](%2,%1)"

--------------------------------------------------------------------------------
-- XMLHttpRequest

data RequestMethod = GET | POST | PUT | HEAD

data ReadyState = UNSENT | OPENED | HEADERS_RECEIVED | LOADING | DONE

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
