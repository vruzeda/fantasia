AbstractSession     = require "../session/AbstractSession"
ClientConfiguration = require "../configurations/ClientConfiguration"

# Controllers
AccountController = require "./AccountController"
RoomController    = require "./RoomController"


class Session extends AbstractSession

  constructor: ->
    super io.connect ClientConfiguration.serverURL

    @accountController = new AccountController @
    @roomController    = new RoomController    @


module.exports = Session