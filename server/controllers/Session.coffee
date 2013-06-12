AbstractSession = require "../../shared/session/AbstractSession"

# Controllers
AccountController = require "./AccountController"
RoomController    = require "./RoomController"


class Session extends AbstractSession

  constructor: (@_sessionManager, socket) ->
    super socket

    @_accountController = new AccountController @
    @_roomController    = new RoomController    @

  register: (@accountId) ->
    @_sessionManager.register @accountId, @

  unregister: ->
    @_sessionManager.unregister @accountId if @accountId?


module.exports = Session