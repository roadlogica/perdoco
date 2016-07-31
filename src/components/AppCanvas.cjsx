React = require("react")

AppCanvas = React.createClass
  displayName: "AppCanvas"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState window.reduxStore.getState()
    )
  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    <div className="row" id="innercanvas">
      <div className="col-md-4">
        <input id="element" />
      </div>
      <div className="col-md-8">
        <span className="glyphicon glyphicon-search" aria-hidden="true"></span>
      </div>
    </div>

module.exports = AppCanvas
