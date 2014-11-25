CookieManager = require "../controllers/CookieManager"


class AccountView

  constructor: (@_session) ->
    unless CookieManager.hasItem "accountId"
      @_showLogin()

    else
      accountId = CookieManager.getItem "accountId"
      @_skipLogin accountId

  _showLogin: ->
    window.location = "/login"

  _skipLogin: (accountId) ->
    @_session.accountController.skipLogin accountId, (error, account) =>
      if error?
        CookieManager.removeItem "accountId"
        @_showLogin()
        return

      CookieManager.setItem "accountId", account.id
      @_showRoom account

  _showRoom: (account) ->
    @_session.viewManager.changeViewTo "RoomView", account


module.exports = AccountView
