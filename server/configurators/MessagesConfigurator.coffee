class MessagesConfigurator

  constructor: ->
    # TODO Instanciate services

  configure: (io) ->
    io.set "log level", 1

    io.sockets.on "connection", (socket) ->
      socket.emit "bla", "ble"


module.exports = MessagesConfigurator