React = require("react")

SmallFace = require './modules/smallface'
EditFace = require './modules/editface'
SavedFaces = require './modules/savedfaces'

AppIdentity = React.createClass
  displayName: "AppIdentity"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      console.log "AppIdentity Msg"
      console.log window.reduxStore.getState()
      @setState window.reduxStore.getState()
    )
  componentWillUnmount: ->
    @unsubscribe()
  saveIdentity: ->
    window.reduxStore.dispatch({type:'SETIDENTITY',group:$('#lbgroupname')[0].value, username:$('#lbusername')[0].value})
    return
  render: ->
    <div id="scrollcontainer">
      <div className="col-sm-6">
        <div className="panel panel-info">
          <div className="panel-heading">Identity</div>
          <div className="panel-body">
            <SmallFace face={@state.config.avatar} />
            <h4>Group</h4>
            <input id="lbgroupname" className="form-control" defaultValue={@state.config.group} />
            <h4>Name</h4>
            <input id="lbusername" className="form-control" defaultValue={@state.config.username} />
            <br />
            <button type="button" className="btn btn-primary" onClick={@saveIdentity}>Save</button>
          </div>
        </div>
      </div>
      <div className="col-sm-6">
        <div className="panel panel-info">
          <div className="panel-heading">Edit Avatar</div>
          <div className="panel-body">
              <EditFace face={@state.config.avatar} dest="AVATAR" />
          </div>
        </div>
      </div>
      <div className="col-sm-12">
        <div className="panel panel-info">
          <div className="panel-heading">Saved Faces</div>
          <div className="panel-body">
              <SavedFaces />
          </div>
        </div>
      </div>
    </div>

module.exports = AppIdentity
