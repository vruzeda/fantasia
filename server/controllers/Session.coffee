AbstractSession = require "../../shared/session/AbstractSession"

# Controllers
AccountController = require "./AccountController"
CommandController = require "./CommandController"
RoomController    = require "./RoomController"


class Session extends AbstractSession

  constructor: (@_sessionManager, socket) ->
    super socket

    @accountController = new AccountController @
    @commandController = new CommandController @
    @roomController    = new RoomController    @

  register: (@accountId) ->
    @_sessionManager.register @accountId, @

  unregister: ->
    @_sessionManager.unregister @accountId if @accountId?


module.exports = Session