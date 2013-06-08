$ = require "../libs/jquery"


class RoomView

  constructor: (@_viewManager, @_session) ->
    $(".header").html "Room"
    $(".room .description").html "Room description"


module.exports = RoomView