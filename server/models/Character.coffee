mongoose = require "mongoose"
ObjectId = mongoose.Schema.ObjectId

Models = require "./Models"


CharacterSchema = mongoose.Schema

  accountId:
    type: ObjectId
    required: true
    unique: true

  currentRoom:
    type: ObjectId
    required: true

  linkingDirection:
    type: String
    required: false

  linkingRoom:
    type: ObjectId
    required: false

CharacterSchema.options.toObject ?= {}
CharacterSchema.options.toObject.virtuals = true


CharacterSchema.statics.create = (accountId, callback) ->
  Universe = Models.get "Universe"
  Universe.getInitialRoom (error, initialRoom) =>
    if error?
      callback error, undefined
      return

    character = new @ {accountId, currentRoom: initialRoom}
    character.save (error) ->
      if error?
        console.error "Error creating character for account ID #{accountId}: #{error.message}"
        callback error, undefined
        return

      callback null, character

CharacterSchema.statics.read = (accountId, callback) ->
  @findOne {accountId}, (error, character) ->
    if error?
      console.error "Error reading character for account ID #{accountId}: #{error.message}"
      callback error, undefined
      return

    if character?
      callback null, character

    else
      console.error "Error reading character for account ID #{accountId}: No such character"
      callback new Error("No such character"), undefined

CharacterSchema.statics.readAllAtRoom = (room, callback) ->
  @find {currentRoom: room.id}, (error, characters) ->
    if error?
      console.error "Error reading characters at room with ID #{room.id}: #{error.message}"
      callback error, undefined
      return

    if characters.length > 0
      callback null, characters

    else
      console.error "Error reading characters at room with ID #{room.id}: Empty room"
      callback new Error("Empty room"), undefined

CharacterSchema.statics.changeRoom = (accountId, newRoom, callback) ->
  @read accountId, (error, character) ->
    if error?
      callback error
      return

    character.currentRoom = newRoom
    character.save (error) ->
      if error?
        console.error "Error changing room for account ID #{accountId}: #{error.message}"
        callback error
        return

      callback null

CharacterSchema.statics.startLink = (accountId, linkingDirectionA, linkingRoomA, callback) ->
  @read accountId, (error, character) ->
    if error?
      callback error
      return

    character.linkingDirection = linkingDirectionA
    character.linkingRoom = linkingRoomA
    character.save (error) ->
      if error?
        console.error "Error starting link for account ID #{accountId}: #{error.message}"
        callback error
        return

      callback null

CharacterSchema.statics.closeLink = (accountId, callback) ->
  @read accountId, (error, character) ->
    if error?
      callback error
      return

    character.linkingDirection = null
    character.linkingRoom = null
    character.save ->
      if error?
        console.error "Error closing link for account ID #{accountId}: #{error.message}"
        callback error
        return

      callback null


module.exports = mongoose.model "Character", CharacterSchema
