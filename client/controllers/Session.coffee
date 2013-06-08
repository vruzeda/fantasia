AbstractSession     = require "../session/AbstractSession"
ClientConfiguration = require "../configurations/ClientConfiguration"

# Controllers
AccountController = require "./AccountController"


class Session extends AbstractSession

  constructor: ->
    super io.connect ClientConfiguration.serverURL

    @accountController = new AccountController @


module.exports = Session