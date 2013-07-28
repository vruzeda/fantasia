socketIO = require "socket.io"
Session  = require "./Session"


class SessionManagerInstance

  constructor: ->
    @_sessions = {}

  configure: (server) ->
    @_listenToServer server

  _listenToServer: (server) ->
    io = socketIO.listen server
    io.set "log level", 1
    io.sockets.on "connection", (socket) =>
      session = new Session @, socket

  register: (accountId, session) ->
    @_sessions[accountId] = session

  unregister: (accountId) ->
    delete @_sessions[accountId]


class SessionManager

  @_instance = null

  @getInstance: ->
    @_instance = new SessionManagerInstance unless @_instance?
    @_instance

  @configure: (server) ->
    instance = @getInstance()
    instance.configure server


module.exports = SessionManager