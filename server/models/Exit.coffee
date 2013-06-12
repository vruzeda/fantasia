mongoose = require "mongoose"
ObjectId = mongoose.Schema.ObjectId

Models = require "./Models"


ExitSchema = mongoose.Schema

  direction:
    type: String
    required: true

  room:
    type: ObjectId
    required: true

ExitSchema.options.toObject ?= {}
ExitSchema.options.toObject.virtuals = true


ExitSchema.statics.create = (direction, room, callback) ->
  exit = new @ {direction, room}
  exit.save (error) ->
    if error?
      callback error, undefined
      return

    callback null, exit

ExitSchema.statics.read = (exitId, callback) ->
  @findById exitId, (error, exit) ->
    if error?
      callback error, undefined
      return

    if exit?
      callback null, exit

    else
      callback new Error("No such exit"), undefined


module.exports = mongoose.model "Exit", ExitSchema