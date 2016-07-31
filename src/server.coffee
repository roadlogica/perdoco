fs = require('fs')
express = require('express')
https = require('https')
http = require('http')
app = express()
isHttps = true
process.argv.forEach (val, index, array) ->
  if val == 'development'
    isHttps = false
  return
if isHttps
  options =
    key: fs.readFileSync('/etc/letsencrypt/live/roadlogica.cn/privkey.pem')
    cert: fs.readFileSync('/etc/letsencrypt/live/roadlogica.cn/cert.pem')
  server = https.createServer(options, app)
else
  server = http.createServer(app)
io = require('socket.io')(server)

getPlayers = ->
  players = []
  for socketId of io.sockets.sockets
    player = io.sockets.sockets[socketId]['userdata']
    if player.mode == 'student'
      players.push
        id: socketId
        userdata: player
  players

io.on 'connection', (socket) ->
  console.log socket.id + ' connected'
  socket['userdata'] =
    group: 'perdoco'
    'username': 'guest'
  socket.on 'remote', (data) ->
    io.emit 'remote', data
    return
  socket.on 'register', (data) ->
    console.log data
    socket['userdata'] = data
    io.emit 'groupmembership', getPlayers()
    return
  socket.on 'disconnect', (data) ->
    console.log socket.id + ' disconnected'
    io.emit 'groupmembership', getPlayers()
    return
  socket.on 'game', (data) ->
    if typeof data.id != 'undefined'
      for socketId of io.sockets.sockets
        if data.id == socketId
          console.log socket.id + ' game data for ' + socketId
          io.emit 'game', data
    else
      console.log socket.id + ' broadcast game data'
      io.emit 'game', data
    return
  socket.on 'gamemove', (data) ->
    console.log socket.id + ' game move'
    data.socketid = socket.id
    io.emit 'gamemove', data
    return
  return

app.use (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  res.header 'Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS'
  next()
  return

app.get '/api/getplayers', (req, res) ->
  res.send JSON.stringify(getPlayers())
  return

app.use express.static(__dirname + '/dist/')

server.listen 3001, ->
  host = server.address().address
  port = server.address().port
  if isHttps
    console.log 'API listening at https://%s:%s, static dir %s', host, port, __dirname + '/html'
  else
    console.log 'API listening at http://%s:%s, static dir %s', host, port, __dirname + '/html'
  return
