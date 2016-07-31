React = require("react")
logo = require './img/perdoco.png'

AppNavbar = React.createClass
  displayName: "AppNavbar"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState window.reduxStore.getState()
    )
  componentWillUnmount: ->
    @unsubscribe()
  notFullScreen: ->
    doc = window.document
    !doc.fullscreenElement and !doc.mozFullScreenElement and !doc.webkitFullscreenElement and !doc.msFullscreenElement
  toggleFullScreen: ->
    doc = window.document
    docEl = doc.documentElement
    requestFullScreen = docEl.requestFullscreen or docEl.mozRequestFullScreen or docEl.webkitRequestFullScreen or docEl.msRequestFullscreen
    cancelFullScreen = doc.exitFullscreen or doc.mozCancelFullScreen or doc.webkitExitFullscreen or doc.msExitFullscreen
    if @notFullScreen()
      requestFullScreen.call docEl
    else
      cancelFullScreen.call doc
    @forceUpdate()
  menu: (menuitem) ->
    window.reduxStore.dispatch({type:'SETSTATE',appstate:menuitem})
    return
  render: ->
    if @notFullScreen()
      fullScreenClass = "glyphicon glyphicon-resize-full"
    else
      fullScreenClass = "glyphicon glyphicon-resize-small"

    back = <li><a href="javascript:void(0)" onClick={() => @menu('CANVAS')}><span className="glyphicon glyphicon-blackboard" />&nbsp;Back</a></li>
    fullscreen = <li><a href="javascript:void(0)" onClick={@toggleFullScreen}><span className={fullScreenClass} />&nbsp;Fullscreen</a></li>
    makeMenu = (->
      if @state.appstate == 'CANVAS'
        <ul className="nav navbar-nav navbar-right">
          {fullscreen}
          <li><a href="javascript:void(0)" onClick={() => @menu('EDITOR')}><span className="glyphicon glyphicon-pencil" />&nbsp;Code</a></li>
          <li><a href="javascript:void(0)" onClick={() => @menu('SAVE')}><span className="glyphicon glyphicon-save-file" />&nbsp;Save</a></li>
          <li><a href="javascript:void(0)" onClick={() => @menu('LOAD')}><span className="glyphicon glyphicon-open-file" />&nbsp;Load</a></li>
        </ul>
      else if @state.appstate == 'JOIN'
        <ul className="nav navbar-nav navbar-right">
          {fullscreen}
          <li><a href="javascript:void(0)" onClick={() => @menu('IDENTITY')}><span className="glyphicon glyphicon-user" />&nbsp;Identity</a></li>
          {back}
        </ul>
      else if @state.appstate == 'IDENTITY'
        <ul className="nav navbar-nav navbar-right">
          {fullscreen}
          <li><a href="javascript:void(0)" onClick={() => @menu('JOIN')}><span className="glyphicon glyphicon-cloud-upload" />&nbsp;Join</a></li>
          {back}
        </ul>
      else
        <ul className="nav navbar-nav navbar-right">
          {fullscreen}
          {back}
        </ul>
    ).bind(this)
    pdMenu = makeMenu()
    <nav className="navbar navbar-default">
      <div className="container-fluid">
        <div className="navbar-header">
          <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
            <span className="sr-only">Toggle navigation</span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
            <span className="icon-bar"></span>
          </button>
          <a className="navbar-brand" href="javascript:void(0)" onClick={() => @menu('IDENTITY')} style={{padding:5,paddingLeft:10,paddingRight:10}}>
            <img src={logo} style={{height:40}} />
          </a>
        </div>
        <div className="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          {pdMenu}
        </div>
      </div>
    </nav>

module.exports = AppNavbar
