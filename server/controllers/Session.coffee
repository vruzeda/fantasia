AbstractSession = require "../../shared/session/AbstractSession"

# Controllers
AccountController = require "./AccountController"


class Session extends AbstractSession

  constructor: (@_sessionManager, socket) ->
    super socket

    @_accountController = new AccountController @

  register: (@_playerId) ->
    @_sessionManager.register @_playerId, @

  unregister: ->
    @_sessionManager.unregister @_playerId if @_playerId?


module.exports = Session