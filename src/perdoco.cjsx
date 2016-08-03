#
# Bootstrap and Core CSS
#
require './vendor/bootstrap/css/bootstrap.css'
require './vendor/bootstrap/js/bootstrap.js'
require './perdoco.css'

React = require 'react'
ReactDOM = require 'react-dom'
{ createStore, compose } = require 'redux'
ls = require './js/_localstorage'

#
# Setup Global Redux Store
#
defaultAppState = {
  appstate:'CANVAS'
  games:[]
  config:ls.getConfig()
}

perdocoRedux = (state = defaultAppState, action) ->
  state.action = action.type
  switch action.type
    when 'SETSTATE'
      return Object.assign({}, state, appstate: action.appstate)
    when 'SETGAMES'
      return Object.assign({}, state, games: action.games)
    when 'SETFACES'
      return Object.assign({}, state, faces: action.faces)
    when 'SETSOURCE'
      return Object.assign({}, state, sourcecode: action.sourcecode)
    when 'USEFACE'
      return Object.assign({}, state, face: action.face)
    when 'SETIDENTITY'
      state.config.group = action.group
      state.config.username = action.username
      return state
    when 'APPLYFACE'
      if action.dest == 'AVATAR'
        state.config.avatar = action.face
        return state
      else
        return Object.assign({}, state, face: action.face, dest: action.dest)
    when 'INITIALLOAD'
      return Object.assign({}, state, action.file)
    when 'LOAD'
      action.file.appstate = 'CANVAS'
      return Object.assign({}, state, action.file)
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
# Socket IO Client
#
console.log 'Perdoco Started'
socket = require('socket.io-client')()

socket.off('connect').on 'connect', (data) ->
  config = ls.getConfig()
  config.mode = 'student'
  socket.emit 'register', config
  return

#
# Full Screen App JS
#
# window.addEventListener 'load', ->
#   $('#msg').html 'load'
#   window.scrollTo 0, 1
#   return

# window.addEventListener 'touchmove', (e) ->
#   e.preventDefault()
#   return

window.msg = (msg) ->
  $('#msg').html msg
  return

window.focused = false
window.setCanvasHeight = ->
  document.getElementById('canvas').setAttribute("style","height:"+window.newHeight+"px");
window.shrinkForKeyboard = ->
  setTimeout (->
    window.scrollTo(0,0)
    window.msg "focus " + window.origHeight + "," + window.innerHeight
    if window.origHeight == window.innerHeight
      window.scrollTo 0, document.body.scrollHeight
      setTimeout (->
        window.msg element.scrollTop
        window.newHeight = window.innerHeight - (window.pageYOffset || window.scrollTop);
        window.msg "focus2 " + window.origHeight + "," + window.newHeight
        window.scrollTo(0,0)
        window.setCanvasHeight()
        return
      ), 500
      return
    else
      window.newHeight = window.innerHeight
      window.setCanvasHeight()
  ), 500

window.onresize = ->
  if /Safari/.test(navigator.userAgent) and /Apple Computer/.test(navigator.vendor)  && window.focused
    window.origHeight = document.body.scrollHeight
    window.msg "Apple Resize "  + window.origHeight + "," + window.innerHeight + ", " + document.body.scrollTop
    if document.body.scrollTop == 0
      window.shrinkForKeyboard()
  else
    window.newHeight = window.innerHeight
    window.msg "resize " + window.focused + " : " + document.body.scrollHeight + "," + window.innerHeight
    window.setCanvasHeight()
  return

window.onload = ->
  window.newHeight = window.innerHeight
  window.setCanvasHeight()
  window.msg navigator.userAgent + " ||| " + navigator.vendor

window.onerror = (errorMsg, url, lineNumber) ->
  window.msg 'Error occured at line ' + lineNumber + ' : ' + errorMsg
  false

window.onbeforeunload = ->
  window.msg "You work will be lost."


resetToTop = ->
  if document.body.scrollTop > 0 or document.documentElement.scrollTop > 0
    window.scrollTo(0,0)
  return

debouncedResetToTop = _.debounce( resetToTop, 1000 )

window.onscroll = ->
  debouncedResetToTop()
  return

ls.loadLbUserFile('_autosave')
