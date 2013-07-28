Controllers = require "./Controllers"

Models    = require "../models/Models"
Character = Models.get "Character"
Exit      = Models.get "Exit"
Room      = Models.get "Room"



class RoomController

  constructor: (@_session) ->
    @_session.on "getCurrentRoom", @getCurrentRoom

  getCurrentRoom: (callback) =>
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    @_getCurrentRoom accountId, (error, currentRoom) ->
      if error?
        callback error, undefined
        return

      callback null, currentRoom.toObject()

  refreshRoom: (callback) ->
    @getCurrentRoom (error, currentRoomObject) =>
      if error?
        callback error
        return

      Character.readAllAtRoom currentRoomObject, (error, characters) =>
        if error?
          callback error
          return

        SessionManager = Controllers.get "SessionManager"

        for character in characters when SessionManager.isOnline character.accountId
          session = SessionManager.getSession character.accountId
          session.send "room", currentRoomObject

        callback null

  createExit: (direction, callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    Room.create "Void", "You see an empty space...", (error, voidRoom) =>
      if error?
        callback error
        return

      @_getCurrentRoom accountId, (error, currentRoom) =>
        if error?
          callback error
          return

        voidRoom.addExit "somewhere", currentRoom, (error) =>
          if error?
            callback error
            return

          currentRoom.addExit direction, voidRoom, (error) =>
            if error?
              callback error
              return

            @refreshRoom callback

  renameExit: (oldDirection, newDirection, callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    @_getCurrentRoom accountId, (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.renameExit oldDirection, newDirection, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  renameRoom: (name, callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    @_getCurrentRoom accountId, (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.renameRoom name, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  describeRoom: (description, callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    @_getCurrentRoom accountId, (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.describeRoom description, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  changeRoom: (direction, callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined

    accountId = @_session.accountId

    @_getCurrentRoom accountId, (error, currentRoom) =>
      if error?
        callback error
        return

      exit = exit for exit in currentRoom.exits when direction.toLowerCase() is exit.direction.toLowerCase()
      if exit?
        Character.update accountId, exit.room, (error) =>
          if error?
            callback error
            return

          @refreshRoom callback

      else
        callback new Error("There's nothing at #{direction}.")

  _getCurrentRoom: (accountId, callback) ->
    Character.read accountId, (error, character) ->
      if error?
        callback error, undefined
        return

      Room.read character.currentRoom, (error, currentRoom) ->
        if error?
          callback error, undefined
          return

        callback null, currentRoom


module.exports = RoomController