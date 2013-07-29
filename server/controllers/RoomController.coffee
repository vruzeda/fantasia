BaseController = require "./BaseController"
Controllers    = require "./Controllers"

Models    = require "../models/Models"
Character = Models.get "Character"
Exit      = Models.get "Exit"
Room      = Models.get "Room"



class RoomController extends BaseController

  constructor: (session) ->
    super session

    @_session.on "getCurrentRoom", @getCurrentRoom

  getCurrentRoom: (callback) =>
    @_getCurrentRoom (error, currentRoom) ->
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
    @_getCurrentRoom (error, currentRoom) =>
      if error?
        callback error
        return

      Room.create "Void", "You see an empty space...", (error, voidRoom) =>
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
    @_getCurrentRoom (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.renameExit oldDirection, newDirection, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  renameRoom: (name, callback) ->
    @_getCurrentRoom (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.renameRoom name, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  describeRoom: (description, callback) ->
    @_getCurrentRoom (error, currentRoom) =>
      if error?
        callback error
        return

      currentRoom.describeRoom description, (error) =>
        if error?
          callback error
          return

        @refreshRoom callback

  changeRoom: (direction, callback) ->
    @_getCurrentRoom (error, currentRoom) =>
      if error?
        callback error
        return

      exit = currentRoom.findExit direction

      if exit?
        Character.update @_session.accountId, exit.room, (error) =>
          if error?
            callback error
            return

          @refreshRoom callback

      else
        callback new Error("There's nothing at #{direction}.")

  _getCurrentRoom: (callback) ->
    @_requireAccountId (error, accountId) =>
      if error?
        callback error, undefined
        return

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