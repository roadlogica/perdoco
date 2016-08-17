lb = require './_lb_lib'
async = require './async'

exports.sendCode = (ip,code) ->
  commands = ['lb={}']
  for key,val of lb
    if typeof val == 'function'
      commands.push uglify("lb." + key + " = " + val.toString())
  commands = commands.concat [
    code.toString()
    code.name + '()'
  ]
  console.log commands
  doFunc = (code, callback) ->
    url = 'http://' + ip + '?eval=' + code
    $.get url, (data, status) ->
      console.log(data)
      callback(false)
    return
  async.eachSeries commands, doFunc, (err) ->
    return
