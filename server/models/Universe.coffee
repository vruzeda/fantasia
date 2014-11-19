mongoose = require "mongoose"
ObjectId = mongoose.Schema.ObjectId

Models = require "./Models"


UniverseSchema = mongoose.Schema

  initialRoom:
    type: ObjectId
    required: true

UniverseSchema.set "toObject", { virtuals: true }


UniverseSchema.statics.create = (callback) ->
  Room = Models.get "Room"
  Room.create "The Temple", "You see yourself in a beautiful, pacific temple.", (error, room) =>
    if error?
      callback error, undefined
      return

    universe = new @ {initialRoom: room.id}
    universe.save (error) ->
      if error?
        console.error "Error creating universe: #{error.message}"
        callback error, undefined
        return

      callback null, universe

UniverseSchema.statics.read = (callback) ->
  @findOne (error, universe) =>
    if error?
      console.error "Error finding universe: #{error.message}"
      callback error, undefined
      return

    if universe?
      callback null, universe

    else
      @create (error, universe) ->
        if error?
          callback error, undefined
          return

        callback null, universe

UniverseSchema.statics.getInitialRoom = (callback) ->
  @read (error, universe) ->
    if error?
      callback error, undefined
      return

    callback null, universe.initialRoom


module.exports = mongoose.model "Universe", UniverseSchema
