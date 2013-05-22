AbstractSession     = require "../session/AbstractSession"
ClientConfiguration = require "../configurations/ClientConfiguration"

# Controllers
AccountController = require "./AccountController"


class Session extends AbstractSession

  constructor: ->
    super io.connect ClientConfiguration.serverURL

    @_accountController = new AccountController @

  register: ->


  unregister: ->


module.exports = Session