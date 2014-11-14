$ = require "../libs/jquery"

BaseCommandView = require "./BaseCommandView"


class RoomView extends BaseCommandView

  constructor: (@_session) ->
    super @_session

    @_session.roomController.getCurrentRoom (error, room) =>
      if error?
        alert error.message
        return

      @drawRoom room

  drawRoom: (room) ->
    $(".room .title").html room.name
    $(".room .description").html room.description.replace /([^.!?])$/, "$1."

    if room.exits?
      exits = (exit.direction for exit in room.exits)

      exitsHtml
      switch exits.length
        when 0
          exitsHtml = ""
        when 1
          exitsHtml = "You see an exit at <a class=\"roomLink\" href=\"javascript:void(0);\">#{exits[0]}</a>"
        else
          exitsHtml = "You see exits at "
          for exit, index in exits[0..-2]
            exitsHtml += ", " if index > 0
            exitsHtml += "<a class=\"roomLink\" href=\"javascript:void(0);\">#{exit}</a>"
          exitsHtml += " and <a class=\"roomLink\" href=\"javascript:void(0);\">#{exits[exits.length - 1]}</a>."

      $(".room .exits").html exitsHtml
      $(".room .exits .roomLink").click (event) =>
        @_session.commandController.executeCommand "go " + $(event.currentTarget).html()


module.exports = RoomView
