class AccountController

  constructor: (@_session) ->

  signUp: (username, password, callback) ->
    @_session.sendAndReceive "signUp", username, password, (error, account) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, account

  signIn: (accountId, callback) ->
    @_session.sendAndReceive "signIn", accountId, (error, account) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, account


module.exports = AccountController
