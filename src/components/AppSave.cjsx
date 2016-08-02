React = require("react")

ls = require '../js/_localstorage'

AppSave = React.createClass
  displayName: "AppSave"
  getInitialState: -> {}
  componentDidMount: ->
    @setState savedgames: ls.loadLbUserFiles()
  savegame: (g) ->
    console.log "save " + g
    ls.saveLbUserFile(g)
    @setState savedgames: ls.loadLbUserFiles()
    return
  deletesavedgame: (g) ->
    o = JSON.parse @state.savedgames
    delete o[g]
    files = JSON.stringify(o)
    @setState savedgames: files
    ls.setLbUserFiles(files)
    return
  render: ->
    that = this
    savedgames = []
    if @state.savedgames
      o = JSON.parse @state.savedgames
      Object.keys(o).forEach ((key, index) ->
        savedgames.push key
        return
      ), o
    showSavedGame = (g) ->
      <div key={g} id={g}  className="col-md-3 col-sm-4 col-xs-6">
        <div className="thumbnail" style={{backgroundColor:'#dff0d8'}}>
          <div className="caption">
            <h4>
              <span className="glyphicon glyphicon-user" />&nbsp;{g}
              <a href="javascript:void(0)" onClick={()=>that.deletesavedgame(g)}>
                <span className="glyphicon glyphicon-trash pull-right" />
              </a>
            </h4>
          </div>
        </div>
      </div>
    <div id="scrollcontainer">
      <div className="col-md-4 col-sm-6 col-xs-12">
        <div className="thumbnail">
          <div className="caption">
            <div className="input-group">
              <span className="input-group-addon">New</span>
              <input id="filename" type="text" className="form-control" aria-label="New Name" />
              <span className="input-group-btn">
                <button style={{fontSize:20}} className="btn btn-default" onClick={()=>that.savegame($('#filename')[0].value)}>
                  <span className="glyphicon glyphicon-check pull-right" />
                </button>
              </span>
            </div>
          </div>
        </div>
      </div>
      {savedgames.map(showSavedGame)}
    </div>

module.exports = AppSave
