uuid = require 'node-uuid'

applications = {}

class Application
  constructor: (@channel, @log) ->
    @entities = {}

    @channel.on 'create', (message) ->
       @log message

class Entity
  constructor: ->
    @components = {}

  clean: ->
    component.clean() for name, component of @components

  sync: ->
    obj = {}
    for name, component of @components
      obj[name] = component.sync() if component.isDirty?


class Component
  constructor: ->
    @fields = {}
    @dirty = {}
    @isDirty = false

  get: (field) -> @fields[field]

  set: (field, value) ->
    @isDirty = true
    @dirty[field] = true if @fields[field] != value
    @fields[field] = value

  clean: ->
    @isDirty = false
    @dirty = {}

  sync: ->
    obj = {}
    for field, value of @fields
      obj[field] = value if @dirty[field]
    return obj

exports.load = ({Channel, log}) ->

  channel = new Channel ''

  channel.on 'ws/ecs/create', (message) ->
    console.log message
    channel.send 'ecs/create', message  

  channel.on 'ecs/create', (message) ->
    console.log message

    newid = uuid.v4()
    applications[newid] = new Application(new Channel("ecs/#{newid}"), log)

    channel.send 'ecs/created', {appid: newid}

  
