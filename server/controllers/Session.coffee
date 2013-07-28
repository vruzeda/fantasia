AbstractSession = require "../../shared/session/AbstractSession"

# Controllers
Controllers = require "./Controllers"


class Session extends AbstractSession

  constructor: (@_sessionManager, socket) ->
    super socket

    AccountController = Controllers.get "AccountController"
    CommandController = Controllers.get "CommandController"
    RoomController    = Controllers.get "RoomController"

    @accountController = new AccountController @
    @commandController = new CommandController @
    @roomController    = new RoomController    @

  register: (@accountId) ->
    @_sessionManager.register @accountId, @

  unregister: ->
    @_sessionManager.unregister @accountId if @accountId?


module.exports = Session