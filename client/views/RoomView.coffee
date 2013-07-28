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

      switch exits.length
        when 0
          $(".room .exits").html ""
        when 1
          $(".room .exits").html "You see an exit at #{exits[0]}."
        else
          $(".room .exits").html "You see exits at #{exits[0..-2].join(", ") + " and " + exits[exits.length - 1]}."


module.exports = RoomView