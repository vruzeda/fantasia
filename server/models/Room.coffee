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

  exits: [
    direction:
      type: String
      required: true

    room:
      type: ObjectId
      required: true
  ]

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

RoomSchema.methods.addExit = (direction, room, callback) ->
  @exits.push {direction, room: room.id}
  @save (error) =>
    if error?
      console.error "Error adding exit to room with ID #{@id}: #{error.message}"
      callback error
      return

    callback null


module.exports = mongoose.model "Room", RoomSchema