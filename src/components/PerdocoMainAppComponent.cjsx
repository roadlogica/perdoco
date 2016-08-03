React = require("react")

AppNavbar = require './AppNavbar'
AppFooter = require './AppFooter'
AppCanvas = require './AppCanvas'
AppIdentity = require './AppIdentity'
AppEditor = require './AppEditor'
AppJoin = require './AppJoin'
AppSave = require './AppSave'
AppLoad = require './AppLoad'

ls = require '../js/_localstorage'

PerdocoMainAppComponent = React.createClass
  displayName: "PerdocoMainAppComponent"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState window.reduxStore.getState()
      ls.autoSaveProject('_autosave')
    )
  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    makeSubComponent = (->
      if @state.appstate == 'CANVAS'
        <AppCanvas />
      else if @state.appstate == 'IDENTITY'
        <AppIdentity />
      else if @state.appstate == 'JOIN'
        <AppJoin />
      else if @state.appstate == 'EDITOR'
        <AppEditor />
      else if @state.appstate == 'LOAD'
        <AppLoad />
      else if @state.appstate == 'SAVE'
        <AppSave />
      else
        <AppIdentity />
    ).bind(this)
    subComponent = makeSubComponent()
    <div id="canvas">
      <AppNavbar />
      {subComponent}
      <AppFooter />
    </div>
module.exports = PerdocoMainAppComponent
