Models  = require "../models/Models"
Account = Models.get "Account"


class AccountController

  constructor: (@_session) ->
    @_session.on "signUp",     @_signUp
    @_session.on "signIn",     @_signIn
    @_session.on "disconnect", @_signOut

  _signUp: (username, callback) =>
    Account.create username, (error, account) =>
      if error?
        callback error, undefined
        return

      @_session.register account.id
      callback null, account.toObject()

  _signIn: (accountId, callback) =>
    Account.read accountId, (error, account) =>
      if error?
        callback error, undefined
        return

      @_session.register account.id
      callback null, account.toObject()

  _signOut: =>
    @_session.unregister()


module.exports = AccountController