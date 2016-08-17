React = require("react")

AppNavbar = require '../components/AppNavbar'
AppFooter = require '../components/AppFooter'
AppIdentity = require '../components/AppIdentity'

TutorMainAppComponent = React.createClass
  displayName: "TutorMainAppComponent",
  render: ->
    <div id="canvas">
      <AppNavbar />
      <div id='gamediv'>
      </div>
      <AppFooter />
    </div>

module.exports = TutorMainAppComponent
