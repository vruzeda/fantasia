class RoomController

  constructor: (@_session) ->
    @_session.on "room", @drawRoom

  getCurrentRoom: (callback) ->
    @_session.sendAndReceive "getCurrentRoom", (error, room) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, room

  drawRoom: (room) =>
    @_session.viewManager.currentView.drawRoom?(room)


module.exports = RoomController