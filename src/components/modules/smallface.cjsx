React = require 'react'
ls = require '../../js/_localstorage'
require './css/face.css'

SmallFace = React.createClass
  getInitialState: ->
    { leds: ls.faceDataToArray(@props.face) }
  render: ->
    @state.leds = ls.faceDataToArray(@props.face)
    if @props.pixelSize?
      pixelSize = Number(@props.pixelSize)
    else
      pixelSize = 4
    r = -1
    c = -1
    ledCol = (col) ->
      if col > 0
        ledStyle = backgroundColor: 'red'
      else
        ledStyle = backgroundColor: 'white'
      ledStyle.width = pixelSize
      ledStyle.height = pixelSize
      <div className="lb-led" style={ledStyle} key={c++}></div>
    ledRow = (row) ->
      c = -1
      ledRowStyle = {
        height : pixelSize
        width : pixelSize * 8
      }
      <div className="lb-ledrow" style={ledRowStyle} key={r++}>
        {row.map(ledCol)}
      </div>
    xsfacestyle = {
      width : pixelSize * 8
      position: @props.position
    }
    <div className="lb-face" style={xsfacestyle} >
      {@state.leds.map(ledRow)}
    </div>

module.exports = SmallFace
