mongoose = require "mongoose"
Q        = require "q"
Models   = require "./Models"


AccountSchema = mongoose.Schema

  username:
    type: String
    required: true
    unique: true

  password:
    type: String
    required: true

  god:
    type: Boolean
    required: true
    default: false

AccountSchema.set "toObject", { virtuals: true }


AccountSchema.statics.create = (username, password) ->
  Q.Promise (resolve, reject, notify) =>
    account = new @ {username, password}
    account.save (error) ->
      if error?
        console.error "Error creating account with username #{username}: #{error.message}"
        reject error
        return

      Character = Models.get "Character"
      Character.create account.id, (error) ->
        if error?
          reject error
          return

        resolve account

AccountSchema.statics.read = (accountId) ->
  Q.Promise (resolve, reject, notify) =>
    @findById accountId, (error, account) ->
      if error?
        console.error "Error reading account with ID #{accountId}: #{error.message}"
        reject error
        return

      unless account?
        console.error "Error reading account with ID #{accountId}: No such account"
        reject new Error "No such account"
        return

      resolve account

AccountSchema.statics.login = (username, password) ->
  Q.Promise (resolve, reject, notify) =>
    @findOne {username, password}, (error, account) ->
      if error?
        console.error "Error reading account with username #{username}: #{error.message}"
        reject error
        return

      unless account?
        console.error "Error reading account with username #{username}: No such account"
        reject new Error "No such account"
        return

      resolve account


module.exports = mongoose.model "Account", AccountSchema
