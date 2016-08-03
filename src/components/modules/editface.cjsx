React = require 'react'
SmallFace = require './smallface'
ls = require '../../js/_localstorage'
require './css/face.css'
Clipboard = require 'clipboard'

EditFace = React.createClass(
  getInitialState: ->
    state = window.reduxStore.getState()
    leds = ls.faceDataToArray(state.config.avatar)
    if @props.data?
      leds = ls.faceDataToArray(@props.face)
    {
      leds: leds
      face: @props.face
    }
  componentDidMount: ->
    new Clipboard('.btn');
    @unsubscribe = window.reduxStore.subscribe((a) =>
      state = window.reduxStore.getState()
      if state.action == 'USEFACE'
        leds = ls.faceDataToArray(state.face)
        @setState leds: leds
    )
  componentWillUnmount: ->
    @unsubscribe()

  itemClick: (r, c) ->
    console.log r + "," + c
    if @state.leds[r][c] == 0
      @state.leds[r][c] = 1
    else
      @state.leds[r][c] = 0
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
  onApplyFace: () ->
    window.reduxStore.dispatch({type:'APPLYFACE',face:@hexString, dest:@props.dest})
    return
  onDeleteSavedFace: (e) ->
    @setState faces: ls.deleteFace(e.target.id)
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

    @hexString = ls.faceArrayToData(@state.leds)
    #document.getElementById('hs').value  = hexString

    if @props.showHex
      showHex = (
        <div className="input-group">
          <span className="input-group-addon">New</span>
          <input id="hs" type="text" className="form-control" aria-label="Hex String" value={@hexString}/>
          <span className="input-group-btn">
            <button style={{fontSize:20}} className="btn btn-default" data-clipboard-target="#hs">
              <span className="glyphicon glyphicon-check pull-right"/>
            </button>
          </span>
        </div>
      )
    <div>
      {showHex}
      <div>
        {this.state.leds.map(ledEditRow)}
      </div>
      <button className="btn btn-danger" onClick={this.onClear}>Clear</button>
      <button className="btn btn-primary" onClick={this.onSave}>Save</button>
      <button className="btn btn-success" onClick={this.onApplyFace}>Apply</button>
    </div>
)

module.exports = EditFace
