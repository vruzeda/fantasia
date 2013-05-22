Communicator = require "../communicator/Communicator"


class AbstractSession

  constructor: (socket) ->
    @_communicator = new Communicator socket

  on: (name, handler) ->
    @_communicator.on name, handler

  send: (name, data...) ->
    @_communicator.send name, data...

  sendAndReceive: (name, data..., callback) ->
    @_communicator.sendAndReceive name, data..., callback


module.exports = AbstractSession