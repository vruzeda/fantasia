mongoose = require "mongoose"
ObjectId = mongoose.Schema.ObjectId

Models = require "./Models"

CountdownLatch = require "../../shared/utils/CountdownLatch"


RoomSchema = mongoose.Schema

  name:
    type: String
    required: true

  description:
    type: String
    required: true

  exits: [ObjectId]

RoomSchema.options.toObject ?= {}
RoomSchema.options.toObject.virtuals = true


RoomSchema.statics.create = (name, description, callback) ->
  room = new @ {name, description}
  room.save (error) ->
    if error?
      console.error "Error creating room with name #{name} and description #{description}: #{error.message}"
      callback error, undefined
      return

    callback null, room

RoomSchema.statics.read = (roomId, callback) ->
  @findById roomId, (error, room) ->
    if error?
      console.error "Error finding room with ID #{roomId}: #{error.message}"
      callback error, undefined
      return

    if room?
      callback null, room

    else
      console.error "Error finding room with ID #{roomId}: No such room"
      callback new Error("No such room"), undefined

RoomSchema.methods.addExit = (direction, roomId, callback) ->
  Room = Models.get "Room"
  Room.read roomId, (error) =>
    if error?
      callback error
      return

    Exit = Models.get "Exit"
    Exit.create direction, roomId, (error, exit) =>
      if error?
        callback error
        return

      @exits.push exit.id
      @save (error) =>
        console.error "Error adding exit to room with ID #{@id}: #{error.message}"
        callback error

RoomSchema.methods.readExits = (callback) ->
  exitIds = @exits
  @exits  = []

  exitsLatch = new CountdownLatch exitIds.length,
    success: ->
      callback null

    error: (error) ->
      callback error

  for exitId in exitIds
    Exit = Models.get "Exit"
    Exit.read exitId, (error, exit) =>
      if error?
        exitsLatch.error error
        return

      @exits.push exit.direction

      exitsLatch.step()


module.exports = mongoose.model "Room", RoomSchema