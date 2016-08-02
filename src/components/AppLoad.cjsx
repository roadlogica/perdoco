React = require("react")

ls = require '../js/_localstorage'

AppLoad = React.createClass
  displayName: "AppLoad"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    that = this
    $.get 'api/listgames', (result) ->
      games = JSON.parse(result)
      that.setState games:games
      window.reduxStore.dispatch({type:'SETGAMES',games:games})
      return
    @setState savedgames: ls.loadLbUserFiles()
  loadgame: (g) ->
    that = this
    $.get 'api/loadgame/'+g, (result) ->
      window.reduxStore.dispatch({type:'SETSOURCE',sourcecode:result})
      window.reduxStore.dispatch({type:'SETSTATE',appstate:'CANVAS'})
      return
    return
  loadsavedgame: (g) ->
    ls.loadLbUserFile(g)
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
        #console.log @[key]
        return
      ), o
    showGame = (g) ->
      <div key={g} id={g} className="col-md-3 col-sm-4 col-xs-6">
        <div className="thumbnail" style={{backgroundColor:'#d9edf7'}}>
          <div className="caption">
            <h4>
              <a href="javascript:void(0)" onClick={()=>that.loadgame(g)}>
                <span className="glyphicon glyphicon-user" />&nbsp;{g}
              </a>
            </h4>
          </div>
        </div>
      </div>
    showSavedGame = (g) ->
      <div key={g} id={g}  className="col-md-3 col-sm-4 col-xs-6">
        <div className="thumbnail" style={{backgroundColor:'#dff0d8'}}>
          <div className="caption">
            <h4>
              <a href="javascript:void(0)" onClick={()=>that.loadsavedgame(g)}>
                <span className="glyphicon glyphicon-user" />&nbsp;{g}
              </a>
              <a href="javascript:void(0)" onClick={()=>that.deletesavedgame(g)}>
                <span className="glyphicon glyphicon-trash pull-right" />
              </a>
            </h4>
          </div>
        </div>
      </div>
    <div id="scrollcontainer">
      {savedgames.map(showSavedGame)}
      {@state.games.map(showGame)}
    </div>

module.exports = AppLoad
