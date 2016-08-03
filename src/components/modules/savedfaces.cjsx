React = require 'react'
SmallFace = require './smallface'
ls = require '../../js/_localstorage'
require './css/face.css'

SavedFaces = React.createClass(
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState appstate: window.reduxStore.getState().appstate
    )
  componentWillUnmount: ->
    @unsubscribe()
  onUseSavedFace: (id) ->
    face = @state.faces[id]
    window.reduxStore.dispatch({type:'USEFACE',face:face})
    return
  onDeleteSavedFace: (id) ->
    @setState faces: ls.deleteFace(id)
    return
  render: ->
    f = 0
    selectFace = ((facedata) ->
      n = f++;
      <span className="selectface" key={n}>
        <div className="btn-group" role="group" aria-label="...">
          <button className="btn btn-default selectfacecontainer" id={n} onClick={()=>@onUseSavedFace(n)}>
            <div className="pull-left faceid">{n}&nbsp;</div>
            <div className="pull-right">
              <SmallFace face={facedata} />
            </div>
          </button>
          <button className="btn btn-default" id={n} onClick={()=>@onDeleteSavedFace(n)}>
            <span className="glyphicon facesglyphicon glyphicon-trash" />
          </button>
        </div>
      </span>
    ).bind(this)

    if @state.faces
      <div>
        {@state.faces.map(selectFace)}
      </div>
    else
      <div>
        No Saved Faces
      </div>
)

module.exports = SavedFaces
