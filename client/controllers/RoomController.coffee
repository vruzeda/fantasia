class RoomController

  constructor: (@_session) ->

  getCurrentRoom: (callback) ->
    @_session.sendAndReceive "getCurrentRoom", (error, room) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, room


module.exports = RoomController