class AccountController

  constructor: (@_session) ->

  signUp: (username, callback) ->
    @_session.sendAndReceive "signUp", username, (error, account) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, account.id

  signIn: (accountId, callback) ->
    @_session.sendAndReceive "signIn", accountId, (error, account) =>
      if error?
        console.error "Error: #{JSON.stringify error}"
        callback error, undefined
        return

      callback null, account.id


module.exports = AccountController