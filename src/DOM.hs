{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}
-- | Document object model functions. Most of this doesn't have
-- anything to do with the DOM and is actually ECMA library stuff, but
-- I'll leave it in for now.

module DOM where

import FFI
import Prelude
import Data.Text

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

getBody :: Fay Element
getBody = ffi "document.body"

getElementById :: Text -> Fay Element
getElementById = ffi "document['getElementById'](%1)"

getElementsByName :: Text -> Fay [Element]
getElementsByName = ffi "document['getElementsByName'](%1)"

addEvent :: Element -> Text -> Fay f -> Fay ()
addEvent = ffi "%1['addEventListener'](%2,%3)"

removeEvent :: Element -> Text -> (Event -> Fay f) -> Fay ()
removeEvent = ffi "%1['removeEventListener'](%2, %3)"

--------------------------------------------------------------------------------
-- Events.

stopProp :: Event -> Fay ()
stopProp = ffi "%1['stopPropagation']()"

preventDefault :: Event -> Fay ()
preventDefault = ffi "%1['preventDefault']()"

--------------------------------------------------------------------------------
-- Element accessors.

createElement :: Text -> Fay Element
createElement = ffi "window['document']['createElement'](%1)"

appendChild :: Element -> Element -> Fay ()
appendChild = ffi "%1['appendChild'](%2)"

appendChildBefore :: Element -> Element -> Fay ()
appendChildBefore = ffi "%1['parentNode']['insertBefore'](%2, %1)"

removeChild :: Element -> Element -> Fay ()
removeChild = ffi "%1['removeChild'](%2)"

parentNode :: Element -> Fay Element
parentNode = ffi "%1['parentNode']"

-- Gets all the child nodes except text, comments etc.
children :: Element -> Fay NodeList
children = ffi "%1['children']"

-- Gets all the child nodes including text, comments etc.
childNodes :: Element -> Fay NodeList
childNodes = ffi "%1['childNodes']"

-- Convert a NodeList to an array
nodeListToArray :: NodeList -> [Element]
nodeListToArray = ffi "Array.prototype.slice.call(%1)"

-- fetch all nodes between two dom nodes
nodesBetween :: Element -> Element -> Fay [Element]
nodesBetween = ffi "\
  \(function(start, end) {\
  \  var i, contents, result = [], parentNode = start.parentNode;\
  \  if(parentNode !== end.parentNode) return;\
  \  contents = Array.prototype.slice.call(parentNode.childNodes);\
  \  for(i=contents.indexOf(start); i<contents.indexOf(end); i++) {\
  \    result.push(contents[i]);\
  \  }\
  \})(%1, %2)"

-- remove all nodes between two dom nodes
removeNodesBetween :: Element -> Element -> Fay ()
removeNodesBetween = ffi "\
  \(function(start, end) {\
  \  var i, contents, parentNode = start.parentNode;\
  \  if(parentNode !== end.parentNode) return;\
  \  contents = Array.prototype.slice.call(parentNode.childNodes);\
  \  for(i=contents.indexOf(start); i<contents.indexOf(end); i++) {\
  \    parentNode.removeChild(contents[i]);\
  \  }\
  \})(%1, %2)"


-- Text nodes require special handling
createTextNode :: Text -> Fay Element
createTextNode = ffi "document['createTextNode'](%1)"

-- Get/Set the text for the text node
getTextData :: Element -> Fay Text
getTextData = ffi "%1['data']"

-- NOTE: This can only be run on text elements
setTextData :: Element -> Text -> Fay ()
setTextData = ffi "%1['data'] = %2"

clearInnerHtml :: Element -> Fay ()
clearInnerHtml = ffi "%1['innerHTML'] = ''"

-- Adding, Removing, and Testing for classes
-- This only works in modern browsers
-- https://developer.mozilla.org/en-US/docs/DOM/element.classList
klass :: Element -> Text -> Fay ()
klass = addClass

addClass :: Element -> Text -> Fay ()
addClass = ffi "%1.classList['add'](%2)"

removeClass :: Element -> Text -> Fay ()
removeClass = ffi "%1['classList']['remove'](%2)"

toggleClass :: Element -> Text -> Fay ()
toggleClass = ffi "%1['classList']['toggle'](%2)"

hasClass :: Element -> Text -> Fay Bool
hasClass = ffi "%1['classList']['contains'](%2)"

--------------------------------------------------------------------------------
-- Attributes

setAttr :: Element -> Text -> Text -> Fay ()
setAttr = ffi "%1['setAttribute'](%2, %3)"

getAttr :: Element -> Text -> Fay Text
getAttr = ffi "%1['getAttribute'](%2)"

hasAttr :: Element -> Text -> Fay Bool
hasAttr = ffi "%1['hasAttribute'](%2)"


--------------------------------------------------------------------------------
-- Form elements

-- Get/Set the value for a textfields/textarea/hidden/password input
-- On checkboxes, this is the value that is sent to the server
getValue :: Element -> Fay Text
getValue = ffi "%1['value']"

setValue :: Element -> Text -> Fay ()
setValue = ffi "%1['value'] = %2"

-- Get/Set the checked status for checkbox
isChecked :: Element -> Fay Bool
isChecked = ffi "%1['checked']"

setChecked :: Element -> Bool -> Fay ()
setChecked = ffi "%1['checked'] = %2"

-- Get the selected value of a radio group
getRadioValue :: Text -> Fay Text
getRadioValue = ffi "\
  \(function(name) {\
  \  var i, rs = document.getElementsByName(name);\
  \  if(rs) {\
  \    for(var i=0; i<rs.length; i++) {\
  \      var radio = rs[i];\
  \      if(radio.type === 'radio' && radio.checked)\
  \        return radio.value;\
  \    }\
  \  }\
  \})(%1)"

-- Set the value of a radio group
setRadioValue :: Text -> Text -> Fay ()
setRadioValue = ffi "\
  \(function(name, val) {\
  \  var i, rs = document.getElementsByName(name);\
  \  if(rs) {\
  \    for(var i=0; i<rs.length; i++) {\
  \      var radio = rs[i];\
  \      if(radio.type === 'radio' && radio.value === val)\
  \        radio.checked = true;\
  \    }\
  \  }\
  \})(%1, %2)"

--------------------------------------------------------------------------------
-- Location

-- Get current URL
getCurrentUrl :: Fay Text
getCurrentUrl = ffi "window['location']['href']"


--------------------------------------------------------------------------------
-- Logging

logS :: Text -> Fay ()
logS = ffi "console['log'](%1)"

logF :: f -> Fay ()
logF = ffi "console['log'](%1)"


--------------------------------------------------------------------------------
-- Timers

-- | setInterval except the calling function gets the timer as an
-- | argument so the interval can be cancelled from within it.
setInterval :: Double -> (Timer -> Fay ()) -> Fay Timer
setInterval = ffi "(function (f,i) { var id = window['setInterval'](function () { f(id); }, i); return id; })(%2,%1)"

clearInterval :: Timer -> Fay ()
clearInterval = ffi "window['clearInterval'](%1)"

-- | setTimeout except the calling function gets the timer as an
-- | argument. Primarily for symmetry with setInterval.
setTimeout :: Double -> (Timer -> Fay ()) -> Fay Timer
setTimeout = ffi "(function (f,i) { var id = window['setTimeout'](function () { f(id); }, i); return id; })(%2,%1)"

clearTimeout :: Timer -> Fay ()
clearTimeout = ffi "window['clearTimeout'](%1)"

--------------------------------------------------------------------------------
-- XHR

data RequestMethod = GET | POST | PUT | HEAD

data ReadyState = UNSENT | OPENED | HEADERS_RECEIVED | LOADING | DONE

xmlHttpRequest :: Fay XMLHttpRequest
xmlHttpRequest = ffi "(function(window) { if(window['XMLHttpRequest']) return new XMLHttpRequest(); else return new ActiveXObject('Microsoft.XMLHTTP'); })(window)"

open :: RequestMethod -> Text -> XMLHttpRequest -> Fay XMLHttpRequest
open = ffi "(function(method, url, xhr) { xhr['open'](method['instance'], url, true); return xhr; })(%1, %2, %3)"

send :: XMLHttpRequest -> Fay ()
send = ffi "%1['send']()"

setReadyStateHandler :: (XMLHttpRequest -> Fay ()) -> XMLHttpRequest -> Fay XMLHttpRequest
setReadyStateHandler = ffi "(function(handler, xhr) { xhr['onreadystatechange'] = function() { handler(xhr); }; return xhr; })(%1, %2)"

readyState :: XMLHttpRequest -> Fay ReadyState
readyState = ffi "{ instance: ['UNSENT', 'OPENED', 'HEADERS_RECEIVED', 'LOADING', 'DONE'][%1['readyState']] }"

responseText :: XMLHttpRequest -> Fay Text
responseText = ffi "%1['responseText']"

status :: XMLHttpRequest -> Fay Int
status = ffi "%1['status']"

--------------------------------------------------------------------------------
-- Utility

-- Read an int
parseInt :: Text -> Fay Int
parseInt = ffi "parseInt(%1, 10)"

-- Scroll a dom element into view
scrollIntoView :: Element -> Fay ()
scrollIntoView = ffi "%1.scrollIntoView()"

-- Scroll the document body by the specified number of pixels
scrollRelative :: Int -> Fay ()
scrollRelative = ffi "window.scrollBy(0,%1)"

-- Scroll the document body to the specified pixel height
scrollAbsolute :: Int -> Fay ()
scrollAbsolute = ffi "window.scrollTo(0,%1)"
