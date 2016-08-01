React = require 'react'

CodeMirror = require '../vendor/codemirror/codemirror.js'
require '../vendor/codemirror/codemirror.css'
require '../vendor/codemirror/javascript.js'
require './AppEditor.css'

AppEditor = React.createClass
  displayName: "AppEditor"
  getInitialState: ->
    window.reduxStore.getState()
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @setState window.reduxStore.getState()
    )
    if /Android/.test(navigator.userAgent)
      inputStyle = 'textarea'
    else
      inputStyle = 'contenteditable'
    @editor = CodeMirror.fromTextArea document.getElementById("code"), {
      lineNumbers: true
      tabSize: 2
      inputStyle: inputStyle
    }
    @editor.setOption 'extraKeys', Space: (cm) ->
      cm.replaceSelection ' '
      return
    @editor.on 'blur', ->
      window.focused = false
      window.newHeight = window.innerHeight
      window.msg "blur " + document.body.scrollHeight + "," + window.innerHeight
      window.setCanvasHeight()
      return
    @editor.on 'focus', ->
      window.focused = true
      window.editorelement = $("#code")
      window.origHeight = document.body.scrollHeight
      if /Safari/.test(navigator.userAgent) and /Apple Computer/.test(navigator.vendor)  && window.focused
        window.shrinkForKeyboard()
      return
  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    <div className="row" id="innercanvas">
      <input id="element" style={{display:'none'}} />
      <form>
      <textarea id="code" name="code">
      </textarea>
      </form>
    </div>

module.exports = AppEditor
