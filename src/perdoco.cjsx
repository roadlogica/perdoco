#
# Bootstrap and Core CSS
#
require './vendor/bootstrap/css/bootstrap.css'
require './vendor/bootstrap/js/bootstrap.js'
require './perdoco.css'
require './favicon.ico'

React = require 'react'
ReactDOM = require 'react-dom'
{ createStore, compose } = require 'redux'

#
# Setup Global Redux Store
#
perdocoRedux = (state = {appstate:'CANVAS'}, action) ->
  switch action.type
    when 'SETSTATE'
      return Object.assign({}, state, appstate: action.appstate)
    when 'FILTER'
      return Object.assign({}, state, visibilityFilter: action.filter)
    when 'TODO'
      return Object.assign({}, state, todos: [ {
        text: action.text
        completed: false
      } ])
    else
      return state
  return

window.reduxStore = createStore(perdocoRedux)

#
# Main App Component
#
PerdocoMainAppComponent = require './components/PerdocoMainAppComponent'
ReactDOM.render <PerdocoMainAppComponent />, document.getElementById 'content'


#
# Socket.io Client and Full Screen App JS
#
console.log 'Perdoco Started'
socket = require('socket.io-client')()
window.addEventListener 'load', ->
  $('#msg').html 'load'
  window.scrollTo 0, 1
  return
document.addEventListener 'touchmove', (e) ->
  $('#msg').html 'TouchMove'
  e.preventDefault()
  return
element = document.getElementById('element')
window.focused = false
window.setCanvasHeight = ->
  document.getElementById('canvas').setAttribute("style","height:"+window.newHeight+"px");
window.shrinkForKeyboard = ->
  setTimeout (->
    window.scrollTo(0,0)
    element.value = "focus " + window.origHeight + "," + window.innerHeight
    if window.origHeight == window.innerHeight
      window.scrollTo 0, document.body.scrollHeight
      setTimeout (->
        window.newHeight = window.innerHeight - (window.pageYOffset || element.scrollTop);
        element.value = "focus2 " + window.origHeight + "," + window.newHeight
        window.scrollTo(0,0)
        window.setCanvasHeight()
        return
      ), 500
    else
      window.newHeight = window.innerHeight
      window.setCanvasHeight()
  ), 500
element.onfocus = ->
  window.focused = true
  window.origHeight = document.body.scrollHeight
  window.shrinkForKeyboard()
  return
window.onresize = ->
  if /Safari/.test(navigator.userAgent) and /Apple Computer/.test(navigator.vendor)  && window.focused
    window.origHeight = document.body.scrollHeight
    window.shrinkForKeyboard()
  else
    window.newHeight = window.innerHeight
    element.value = "resize " + window.focused + " : " + document.body.scrollHeight + "," + window.innerHeight
    window.setCanvasHeight()
  return
element.onblur = ->
  window.focused = false
  window.newHeight = window.innerHeight
  element.value = "blur " + document.body.scrollHeight + "," + window.innerHeight
  window.setCanvasHeight()
  return
window.onload = ->
  window.newHeight = window.innerHeight
  window.setCanvasHeight()
