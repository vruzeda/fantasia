$ = require "../libs/jquery"


class RoomView

  constructor: (@_viewManager, @_session) ->
    @_session.roomController.getCurrentRoom (error, room) ->
      if error?
        alert error.message
        return

      $(".room .title").html room.name
      $(".room .description").html room.description


module.exports = RoomView