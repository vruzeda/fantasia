AbstractSession     = require "../session/AbstractSession"
ClientConfiguration = require "../configurations/ClientConfiguration"

# Controllers
AccountController = require "./AccountController"
CommandController = require "./CommandController"
RoomController    = require "./RoomController"


class Session extends AbstractSession

  constructor: (@viewManager) ->
    super io.connect ClientConfiguration.serverURL

    @accountController = new AccountController @
    @commandController = new CommandController @
    @roomController    = new RoomController    @


module.exports = Session