exports.getFaces = ->
  storage = window.localStorage
  if !storage.getItem('faces')
    storage.setItem 'faces', JSON.stringify([])
  JSON.parse storage.getItem('faces')

exports.storeFace = (face) ->
  storage = window.localStorage
  faces = exports.getFaces()
  faces.push face
  storage.setItem 'faces', JSON.stringify(faces)
  faces

exports.deleteFace = (index) ->
  storage = window.localStorage
  faces = exports.getFaces()
  faces.splice index, 1
  storage.setItem 'faces', JSON.stringify(faces)
  faces

exports.saveLbUserFile = (f) ->
  storage = window.localStorage
  if !storage.getItem('files')
    storage.setItem 'files', JSON.stringify({})
  files = JSON.parse(storage.getItem('files'))
  files[f] = document.getElementById('view').innerText
  storage.setItem 'files', JSON.stringify(files)
  return

exports.loadLbUserFile = (f) ->
  storage = window.localStorage
  if !storage.getItem('files')
    storage.setItem 'files', JSON.stringify({})
  files = JSON.parse(storage.getItem('files'))
  file = files[f]
  if typeof file == 'undefined'
    return ''
  file

exports.loadProjects = ->
  storage = window.localStorage
  if !storage.getItem('projects')
    storage.setItem 'projects', JSON.stringify({})
  projects = JSON.parse(storage.getItem('projects'))
  projects

exports.saveProject = (name, obj) ->
  storage = window.localStorage
  projects = loadProjects()
  projects[name] = obj
  storage.setItem 'projects', JSON.stringify(projects)
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

require 'lodash'

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

exports.autoSaveProject = _.debounce(exports.saveProject, 500)
exports.data_smiley = '0066660081423c00'
exports.leds_smiley = exports.faceDataToArray exports.data_smiley
