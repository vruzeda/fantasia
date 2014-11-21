socketIO = require "socket.io"
Session  = require "./Session"


class SessionManagerInstance

  constructor: ->
    @_sessions = {}

  configure: (serverPort) ->
    @_listenToServer serverPort

  _listenToServer: (serverPort) ->
    io = socketIO.listen serverPort + 1
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
