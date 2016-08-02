require 'lodash'

exports.getFaces = ->
  faces = window.reduxStore.getState().faces
  if faces?
    faces
  else
    []

exports.storeFace = (face) ->
  faces = exports.getFaces()
  faces.push face
  window.reduxStore.dispatch({type:'SETFACES',faces:faces})
  faces

exports.deleteFace = (index) ->
  storage = window.localStorage
  faces = exports.getFaces()
  faces.splice index, 1
  window.reduxStore.dispatch({type:'SETFACES',faces:faces})
  faces

exports.saveLbUserFile = (f) ->
  state = window.reduxStore.getState()
  storage = window.localStorage
  if !storage.getItem('files')
    storage.setItem 'files', JSON.stringify({})
  files = JSON.parse(storage.getItem('files'))
  files[f] = state
  storage.setItem 'files', JSON.stringify(files)
  return

exports.loadLbUserFile = (f) ->
  console.log "loadLbUserFile " + f
  storage = window.localStorage
  files = storage.getItem('files')
  if !files
    storage.setItem 'files', JSON.stringify({})
  files = JSON.parse(storage.getItem('files'))
  file = files[f]
  if file?
    if f == '_autosave'
      window.reduxStore.dispatch({type:'INITIALLOAD',file})
    else
      window.reduxStore.dispatch({type:'LOAD',file})
  file

exports.loadLbUserFiles = () ->
  storage = window.localStorage
  files = storage.getItem('files')
  if !files
    storage.setItem 'files', JSON.stringify({})
  o = JSON.parse(files)
  delete o['_autosave']
  JSON.stringify o

exports.setLbUserFiles = (files) ->
  storage = window.localStorage
  storage.setItem 'files', files
  return

exports.faceDataToArray = (str) ->
  if typeof str == 'undefined'
    str = data_smiley
  result = []
  while str.length >= 2
    byte = parseInt(str.substring(0, 2), 16)
    bytearray = []
    b = 7
    while b >= 0
      mask = 1 << b
      bit = byte & mask
      if bit > 1
        bit = 1
      bytearray.push bit
      b--
    result.push bytearray
    str = str.substring(2, str.length)
  result

exports.faceArrayToData = (arr) ->
  hs = ''
  data = arr.map((row) ->
    b = 0x00
    for i of row
      v = row[i]
      b = b << 1
      b += v
    h = b.toString(16)
    hs = hs + ('00' + h).slice(-2)
    b
  )
  hs

exports.getConfig = ->
  storage = window.localStorage
  if !storage.getItem('config')
    storage.setItem 'config', JSON.stringify(
      group: 'perdoco'
      username: 'guest'
      avatar: exports.data_smiley)
  JSON.parse storage.getItem('config')

exports.storeConfig = (config) ->
  storage = window.localStorage
  storage.setItem 'config', JSON.stringify(config)
  return

exports.autoSaveProject = _.debounce(exports.saveLbUserFile, 1000)
exports.data_smiley = '0066660081423c00'
exports.leds_smiley = exports.faceDataToArray exports.data_smiley
