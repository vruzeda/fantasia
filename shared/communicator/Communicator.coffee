class Communicator

  constructor: (@_socket) ->
    @_handlers = {}

    @_socket.on "connect", =>
      @_handleEvent "connect"

    @_socket.on "disconnect", =>
      @_handleEvent "disconnect"

    @_socket.on "event", (json, callback) =>
      {name, data} = JSON.parse json
      @_handleEvent name, data..., callback

  _handleEvent: (name, data..., callback) ->
    return unless @_handlers[name]?

    handler data..., callback for handler in @_handlers[name]

  on: (name, handler) ->
    @_handlers[name] ?= []
    @_handlers[name].push handler

  send: (name, data...) ->
    @_socket.emit "event", JSON.stringify({name, data})

  sendAndReceive: (name, data..., callback) ->
    @_socket.emit "event", JSON.stringify({name, data}), callback


module.exports = Communicator