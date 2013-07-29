class BaseController

  constructor: (@_session) ->

  _requireAccountId: (callback) ->
    unless @_session.accountId?
      callback new Error("Unauthorized action. You must login first."), undefined
      return

    callback null, @_session.accountId


module.exports = BaseController