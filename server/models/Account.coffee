mongoose = require "mongoose"


AccountSchema = mongoose.Schema

  name:
    type: String
    required: true
    unique: true

  god:
    type: Boolean
    required: true
    default: false

AccountSchema.options.toObject ?= {}
AccountSchema.options.toObject.virtuals = true


AccountSchema.statics.create = (name, callback) ->
  account = new @ {name}
  account.save (error) ->
    if error?
      callback error, undefined
      return

    callback null, account.toObject()

AccountSchema.statics.read = (accountId, callback) ->
  @findById accountId, (error, account) ->
    if error?
      callback error, undefined
      return

    if account?
      callback null, account.toObject()

    else
      callback new Error("No such user"), undefined


module.exports = mongoose.model "Account", AccountSchema