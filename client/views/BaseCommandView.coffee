class BaseCommandView

  constructor: (session) ->
    $(".execute").unbind "submit"
    $(".execute").submit (event) ->
      event.preventDefault()

      command = $(".execute .command").val()
      $(".execute .command").val ""
      session.commandController.executeCommand command


module.exports = BaseCommandView
