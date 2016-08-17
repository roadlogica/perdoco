#
# Bootstrap and Core CSS
#
require './vendor/bootstrap/css/bootstrap.css'
require './vendor/bootstrap/js/bootstrap.js'
require './favicon.ico'
require './perdoco.css'

React = require 'react'
ReactDOM = require 'react-dom'

React = require 'react'
ReactDOM = require 'react-dom'
{ createStore, compose } = require 'redux'
ls = require './js/_localstorage'

#
# Main App Component
#
TutorMainAppComponent = require './tutor/TutorMainAppComponent'

#
# Socket.io Client
#
console.log 'Perdoco Tutor Started'
socket = require('socket.io-client')()


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
    when 'LOAD'
      action.file.appstate = 'CANVAS'
      return Object.assign({}, state, action.file)
    else
      return state
  return

window.reduxStore = createStore(perdocoRedux)

GetURLParameter = (sParam) ->
  sPageURL = window.location.search.substring(1)
  sURLVariables = sPageURL.split('&')
  i = 0
  while i < sURLVariables.length
    sParameterName = sURLVariables[i].split('=')
    if sParameterName[0] == sParam
      return sParameterName[1]
    i++
  return


loadTutorGame = (game) ->
  $.ajax '/loadgame/'+game,
    success  : (res, status, xhr) ->
      scriptelement = $('lbscript')
      if element
        element.parentNode.removeChild element
      element = document.createElement('SCRIPT')
      element.type = 'text/javascript'
      element.id = 'lbscript'
      element.innerHTML = res
      document.getElementsByTagName('BODY')[0].appendChild element
    error    : (xhr, status, err) ->
      return
    complete : (xhr, status) ->
      return
  return

game = GetURLParameter('loadgame')

if game?
  loadTutorGame(game)

ReactDOM.render <TutorMainAppComponent />, document.getElementById 'content'
