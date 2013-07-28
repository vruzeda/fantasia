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

CharacterSchema.statics.update = (accountId, currentRoom, callback) ->
  @read accountId, (error, character) ->
    if error?
      callback error
      return

    character.currentRoom = currentRoom
    character.save (error) ->
      if error?
        console.error "Error updating character for account ID #{accountId}: #{error.message}"
        callback error
        return

      callback null


module.exports = mongoose.model "Character", CharacterSchema