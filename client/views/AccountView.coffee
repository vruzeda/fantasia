CookieManager = require "../controllers/CookieManager"


class AccountView

  constructor: (@_session) ->
    unless CookieManager.hasItem "accountId"
      @_showLogin()

    else
      accountId = CookieManager.getItem "accountId"
      @_skipLogin accountId

  _showLogin: ->
      $(".login").removeClass "hidden"
      $(".login .signUp").off "submit"
      $(".login .signUp").submit (event) =>
        event.preventDefault()

        username = $(".login .signUp .username").val()
        $(".login .signUp .username").val ""
        password = $(".login .signUp .password").val()
        $(".login .signUp .password").val ""
        @_signUp username, password

      $(".login .signIn").off "submit"
      $(".login .signIn").submit (event) =>
        event.preventDefault()

        username = $(".login .signIn .username").val()
        $(".login .signIn .username").val ""
        password = $(".login .signIn .password").val()
        $(".login .signIn .password").val ""
        @_signIn username, password

  _signUp: (username, password) ->
    @_session.accountController.signUp username, password, (error, account) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", account.id
      @_showRoom account

  _signIn: (username, password) ->
    @_session.accountController.signIn username, password, (error, account) =>
      if error?
        CookieManager.removeItem "accountId"
        @_showLogin()
        return

      CookieManager.setItem "accountId", account.id
      @_showRoom account

  _skipLogin: (accountId) ->
    @_session.accountController.skipLogin accountId, (error, account) =>
      if error?
        CookieManager.removeItem "accountId"
        @_showLogin()
        return

      CookieManager.setItem "accountId", account.id
      @_showRoom account

  _showRoom: (account) ->
    $(".login").addClass "hidden"
    @_session.viewManager.changeViewTo "RoomView", account


module.exports = AccountView
