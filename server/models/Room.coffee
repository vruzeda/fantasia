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

RoomSchema.methods.renameRoom = (name, callback) ->
  @name = name
  @save (error) =>
    if error?
      console.error "Error renaming room with ID #{@id}: #{error.message}"
      callback error
      return

    callback null

RoomSchema.methods.describeRoom = (description, callback) ->
  @description = description
  @save (error) =>
    if error?
      console.error "Error describing room with ID #{@id}: #{error.message}"
      callback error
      return

    callback null

RoomSchema.methods.renameExit = (oldDirection, newDirection, callback) ->
  @removeExit oldDirection, (error, exit) =>
    if error?
      callback error, undefined
      return

    @addExit newDirection, {id: exit.room}, (error, exit) =>
      if error?
        callback error, undefined
        return

      callback null, exit

RoomSchema.methods.addExit = (direction, room, callback) ->
  {exit} = @_findExit direction

  if exit?
    console.error "Error adding exit to room with ID #{@id}: Duplicated exit at \"#{direction}\""
    callback new Error("Duplicated exit at \"#{direction}\""), undefined

  else
    @exits.push {direction, room: room.id}
    @save (error) =>
      if error?
        console.error "Error adding exit to room with ID #{@id}: #{error.message}"
        callback error, undefined
        return

      callback null, exit

RoomSchema.methods.removeExit = (direction, callback) ->
  {exit, index} = @_findExit direction

  unless index?
    console.error "Error removing exit from room with ID #{@id}: No exit at #{direction}"
    callback new Error("No exit at #{direction}"), undefined

  else
    @exits.splice index, 1
    @save (error) =>
      if error?
        console.error "Error removing exit from room with ID #{@id}: #{error.message}"
        callback error, undefined
        return

      callback null, exit

RoomSchema.methods._findExit = (direction) ->
  return {exit, index} for exit, index in @exits when direction.toLowerCase() is exit.direction.toLowerCase()
  return {}


module.exports = mongoose.model "Room", RoomSchema