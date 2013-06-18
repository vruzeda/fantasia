COMMANDS =
  refresh:    /^refresh/i
  createRoom: /^create room "([^"]*)" at "([^"]*)"/i
  changeRoom: /^go "([^"]*)"/i


class CommandController

  constructor: (@_session) ->
    @_session.on "executeCommand", @executeCommand

  executeCommand: (command, callback) =>
    command = command.trim()
    commandFound = false

    commandFound or= @_isCommand COMMANDS.refresh, command, =>
      @_session.roomController.refreshRoom callback

    commandFound or= @_isCommand COMMANDS.createRoom, command, (name, direction) =>
      @_session.roomController.createRoom name, direction, callback

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