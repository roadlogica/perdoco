React = require 'react'
SmallFace = require './smallface'
ls = require '../../js/_localstorage'
require './css/face.css'

EditFace = React.createClass(
  getInitialState: ->
    leds = ls.faceDataToArray('0000000000000000')
    if @props.data?
      leds = ls.faceDataToArray(@props.face)
    {
      leds: leds
      face: @props.face
      faces: ls.getFaces()
    }
  itemClick: (r, c) ->
    if @state.leds[r][c] == 0
      @state.leds[r][c] = 1
    else
      @state.leds[r][c] = 0
    @setState msg : null
    @setState led: @state.leds
    return
  onClear: ->
    @setState leds: ls.faceDataToArray('0000000000000000')
    return
  onSave: ->
    hs = ls.faceArrayToData(@state.leds)
    @setState faces: ls.storeFace(hs)
    return
  onLoadSavedFace: (e) ->
    @setState leds: ls.faceDataToArray(@state.faces[e.target.id])
    return
  onUseSavedFace: (e) ->
    return
  onDeleteSavedFace: (e) ->
    @setState faces: ls.deleteFace(e.target.id)
    return
  copyHex: (hexString) ->
    try
      document.getElementById("hs").select()
      successful = document.execCommand('copy')
      msg = if successful then 'successful' else 'unsuccessful'
      @setState msg : 'Copying hex string was ' + msg
    catch err
      @setState msg : 'Oops, unable to copy'
    return
  render: ->
    r = -1
    c = -1
    ledEditCol = ((col) ->
      if col > 0
        ledStyle =
          backgroundColor: 'red'
      else
        ledStyle =
          backgroundColor: '#fff'
      <div className="lb-led-edit" style={ledStyle} key={c++} onClick={this.itemClick.bind(this,r,c)}></div>
    ).bind(this)


    ledEditRow = (row) ->
      c = -1
      <div className="lb-led-editrow" key={r++}>
        {row.map(ledEditCol)}
      </div>

    f = -1
    selectFace = ((facedata) ->
      <span className="selectface" key={f++}>
        <span className="selectfacecontainer">
          <SmallFace face={facedata} />
        </span>
        <button className="btn btn-default" id={f} onClick={@onDeleteSavedFace}>
          <span className="glyphicon glyphicon-trash" />
        </button>
      </span>
    ).bind(this)

    hexString = ls.faceArrayToData(@state.leds)
    console.log @state.faces
    <div>
      <h4 onClick={() => @copyHex(hexString)}><pre id="hs">{hexString}</pre>&nbsp;<span className="glyphicon glyphicon-copy" />&nbsp;Copy</h4>
      <small>{@state.msg}</small>
      <br />
      <div>
        {this.state.leds.map(ledEditRow)}
      </div>
      <br />
      <button className="btn btn-danger" onClick={this.onClear}>Clear</button>
      <button className="btn btn-primary" onClick={this.onSave}>Save</button>
      <h4>Saved Faces</h4>
      {this.state.faces.map(selectFace)}
    </div>
)

module.exports = EditFace
