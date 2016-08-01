React = require("react")

SmallFace = require './modules/smallface'
EditFace = require './modules/editface'

AppIdentity = React.createClass
  displayName: "AppIdentity"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState window.reduxStore.getState()
    )

  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    <div id="scrollcontainer">
      <div className="col-sm-6">
        <div className="panel panel-info">
          <div className="panel-heading">Identity</div>
          <div className="panel-body">
            <SmallFace face={@state.config.avatar} pixelSize=4 />
            <h4>Group</h4>
            <input className="form-control" value={@state.config.group} />
            <h4>Name</h4>
            <input className="form-control" value={@state.config.username} />
            <br />
            <button type="button" className="btn btn-primary">Save</button>
          </div>
        </div>
      </div>
      <div className="col-sm-6">
        <div className="panel panel-info">
          <div className="panel-heading">Edit Avatar</div>
          <div className="panel-body">
            <EditFace face={@state.config.avatar} />
          </div>
        </div>
      </div>
    </div>

module.exports = AppIdentity
