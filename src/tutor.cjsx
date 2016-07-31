#
# Bootstrap and Core CSS
#
require './vendor/bootstrap/css/bootstrap.css'
require './vendor/bootstrap/js/bootstrap.js'
require './favicon.ico'

React = require 'react'
ReactDOM = require 'react-dom'

window.React = React
window.ReactDOM = ReactDOM

#
# Main App Component
#
TutorMainAppComponent = require './tutor/TutorMainAppComponent'
ReactDOM.render <TutorMainAppComponent />, document.getElementById 'content'

#
# Socket.io Client
#
console.log 'Perdoco Tutor Started'
socket = require('socket.io-client')()

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
