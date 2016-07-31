React = require("react")

AppFooter = React.createClass
  displayName: "AppFooter"

  render: ->
    <div id="footer">
      <span id="msg" />
    </div>

module.exports = AppFooter
