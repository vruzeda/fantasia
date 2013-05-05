class MessagesConfigurator

  constructor: ->
    # TODO Instanciate services

  configure: (io) ->
    io.sockets.on "connection", (socket) ->
      socket.emit "bla", "ble"


module.exports = MessagesConfigurator