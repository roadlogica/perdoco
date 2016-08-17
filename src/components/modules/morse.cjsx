React = require 'react'

Morse = React.createClass
  getInitialState: ->
    {
      timer : null
      started : false
      configString : null
      nextChar : null
      bitsRemaining : 0
      bitval : null
      entrytime : 500
      bittime : 10
    }
  bitBang: ->
    that = this
    if @state.nextChar == null
      if @state.configString.length > 0
        @state.nextChar = @state.configString.substring(0,1)
        @state.configString = @state.configString.substring(1)
        @state.bitsRemaining = 8
        @state.hex = ('00' + @state.nextChar.charCodeAt(0).toString(16)).substr(-2,2)
        # if @state.nextChar >= ' ' and @state.nextChar <= '~'
        #   console.log "BYTE : " + hex + " (" + @state.nextChar + ")"
        # else
        #   console.log "BYTE : " + hex
        return
      else
        setTimeout (->
          $('#morse').hide()
          $('.navbar').show()
          clearInterval that.state.timer
          that.state.started = false
          that.state.timer = null
        ), @state.entrytime
        return

    bitmask = Math.pow(2,--@state.bitsRemaining)
    bit = ((bitmask & @state.nextChar.charCodeAt(0)) == bitmask)
    console.log @state.hex + " : " + bitmask + "," + bit

    if bit
      $("#morse").css("background-color","white")
    else
      $("#morse").css("background-color","black")

    if @state.bitsRemaining == 0
      @state.nextChar = null
    return
  componentDidMount: ->
    @unsubscribe = window.reduxStore.subscribe(() =>
      @rd = window.reduxStore.getState()
      if @rd.action == 'CONFIGROBOT'
        if !@state.started
          console.log "START CONFIG"
          $('.navbar').hide()
          $('#morse').show()
          @state.configString = String.fromCharCode(0x55) + String.fromCharCode(0xAA)
          @state.configString += String.fromCharCode(@rd.config.ssid.length)
          @state.configString += String.fromCharCode(@rd.config.password.length)
          @state.configString += @rd.config.ssid  + @rd.config.password
          @state.configString += String.fromCharCode(0xAA) + String.fromCharCode(0x55)
          that = this
          setTimeout (->
            that.state.timer = setInterval(that.bitBang, that.state.bittime)
            return
          ), @state.entrytime
    )
  componentWillUnmount: ->
    @unsubscribe()
  render: ->
    fullscreenmorse = {
      backgroundColor : 'black'
      position : 'absolute'
      width : '100vw'
      height: '100vh'
      display: 'none'
    }

    <div id="morse" style={fullscreenmorse} >
    </div>

module.exports = Morse
