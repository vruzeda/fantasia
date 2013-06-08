$ = require "../libs/jquery"


class RoomView

  constructor: (@_viewManager, @_session) ->
    $(".room .title").html "Room title"
    $(".room .description").html "Room description"


module.exports = RoomView