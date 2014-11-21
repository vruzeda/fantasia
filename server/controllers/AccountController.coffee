Q              = require "q"
BaseController = require "./BaseController"
Models         = require "../models/Models"

Account = Models.get "Account"


class AccountController extends BaseController

  constructor: (session) ->
    super session

    @_session.on "signUp",     @signUp
    @_session.on "signIn",     @signIn
    @_session.on "skipLogin",  @skipLogin
    @_session.on "disconnect", @signOut

  signUp: (username, password, callback) =>
    Account.create username, password
    .then (account) =>
      @_session.register account.id
      callback null, account.toObject()
    .fail (error) =>
      callback error, undefined

  signIn: (username, password, callback) =>
    Account.login username, password, (error, account) =>
      if error?
        callback error, undefined
        return

      @_session.register account.id
      callback null, account.toObject()

  skipLogin: (accountId, callback) =>
    Account.read accountId
    .then (account) =>
      @_session.register account.id
      callback null, account.toObject()
    .fail (error) =>
      callback error, undefined

  signOut: =>
    @_session.unregister()


module.exports = AccountController
