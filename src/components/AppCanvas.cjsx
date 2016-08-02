React = require("react")

AppCanvas = React.createClass
  displayName: "AppCanvas"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      if @state.appstate == 'CANVAS'
        console.log "AppCanvas Subscription"
        @setState window.reduxStore.getState()
    )
  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    <div className="row" id="innercanvas">
    </div>

module.exports = AppCanvas
