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

  isOnline: (accountId) ->
    @_sessions[accountId]?

  getSession: (accountId) ->
    @_sessions[accountId]


class SessionManager

  @_instance = null

  @getInstance: ->
    @_instance = new SessionManagerInstance unless @_instance?
    @_instance

  @configure: (server) ->
    instance = @getInstance()
    instance.configure server

  @isOnline: (accountId) ->
    instance = @getInstance()
    instance.isOnline accountId

  @getSession: (accountId) ->
    instance = @getInstance()
    instance.getSession accountId


module.exports = SessionManager