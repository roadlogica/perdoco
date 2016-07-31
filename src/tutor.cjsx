#
# Bootstrap and Core CSS
#
require './vendor/bootstrap/css/bootstrap.css'
require './vendor/bootstrap/js/bootstrap.js'
require './favicon.ico'

React = require 'react'
ReactDOM = require 'react-dom'

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
