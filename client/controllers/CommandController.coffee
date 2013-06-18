class CommandController

  constructor: (@_session) ->

  executeCommand: (command, callback = ->) ->
    @_session.sendAndReceive "executeCommand", command, (error) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error
        return

      callback null


module.exports = CommandController