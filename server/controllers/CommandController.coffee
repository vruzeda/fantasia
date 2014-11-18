validator      = require "validator"
BaseController = require "./BaseController"

COMMANDS =
  refresh:      /^refresh/i
  createExit:   /^create exit ([^:]*)/i
  startLink:    /^start link ([^:]*)/i
  closeLink:    /^close link ([^:]*)/i
  renameExit:   /^rename exit ([^:]*):([^:]*)/i
  renameRoom:   /^rename room ([^:]*)/i
  describeRoom: /^describe room (.*)/i
  changeRoom:   /^go ([^:]*)/i


class CommandController extends BaseController

  constructor: (session) ->
    super session

    @_session.on "executeCommand", @executeCommand

  executeCommand: (command, callback) =>
    command = validator.escape command.trim()
    commandFound = false

    commandFound or= @_isCommand COMMANDS.refresh, command, =>
      @_session.roomController.refreshRoom callback

    commandFound or= @_isCommand COMMANDS.createExit, command, (direction) =>
      @_session.roomController.createExit direction, callback

    commandFound or= @_isCommand COMMANDS.startLink, command, (direction) =>
      @_session.roomController.startLink direction, callback

    commandFound or= @_isCommand COMMANDS.closeLink, command, (direction) =>
      @_session.roomController.closeLink direction, callback

    commandFound or= @_isCommand COMMANDS.renameExit, command, (oldDirection, newDirection) =>
      @_session.roomController.renameExit oldDirection, newDirection, callback

    commandFound or= @_isCommand COMMANDS.renameRoom, command, (name) =>
      @_session.roomController.renameRoom name, callback

    commandFound or= @_isCommand COMMANDS.describeRoom, command, (description) =>
      @_session.roomController.describeRoom description, callback

    commandFound or= @_isCommand COMMANDS.changeRoom, command, (direction) =>
      @_session.roomController.changeRoom direction, callback

    unless commandFound
      console.error "Unknown command: #{command}"
      callback new Error("Unknown command")

  _isCommand: (regex, string, callback) ->
    if regex.test string
      callback regex.exec(string).slice(1)...
      true

    else
      false


module.exports = CommandController
