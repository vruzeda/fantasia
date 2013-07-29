BaseController = require "./BaseController"

Models  = require "../models/Models"
Account = Models.get "Account"


class AccountController extends BaseController

  constructor: (session) ->
    super session

    @_session.on "signUp",     @signUp
    @_session.on "signIn",     @signIn
    @_session.on "disconnect", @signOut

  signUp: (username, callback) =>
    Account.create username, (error, account) =>
      if error?
        callback error, undefined
        return

      @_session.register account.id
      callback null, account.toObject()

  signIn: (accountId, callback) =>
    Account.read accountId, (error, account) =>
      if error?
        callback error, undefined
        return

      @_session.register account.id
      callback null, account.toObject()

  signOut: =>
    @_session.unregister()


module.exports = AccountController