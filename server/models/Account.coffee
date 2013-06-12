mongoose = require "mongoose"

Models = require "./Models"


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
      console.error "Error creating account with name #{name}: #{error.message}"
      callback error, undefined
      return

    Character = Models.get "Character"
    Character.create account.id, (error) ->
      if error?
        callback error, undefined
        return

      callback null, account

AccountSchema.statics.read = (accountId, callback) ->
  @findById accountId, (error, account) ->
    if error?
      console.error "Error reading account with ID #{accountId}: #{error.message}"
      callback error, undefined
      return

    if account?
      callback null, account

    else
      console.error "Error reading account with ID #{accountId}: No such account"
      callback new Error("No such account"), undefined


module.exports = mongoose.model "Account", AccountSchema