Models    = require "../models/Models"
Character = Models.get "Character"
Room      = Models.get "Room"


class RoomController

  constructor: (@_session) ->
    @_session.on "getCurrentRoom", @_getCurrentRoom

  _getCurrentRoom: (callback) =>
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    else
      accountId = @_session.accountId

      Character.read accountId, (error, character) ->
        if error?
          callback error, undefined
          return

        Room.read character.currentRoom, (error, room) ->
          if error?
            callback error, undefined
            return

          callback null, room.toObject()


module.exports = RoomController