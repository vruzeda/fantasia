$ = require "../libs/jquery"

CookieManager = require "../controllers/CookieManager"


class AccountView

  constructor: (@_viewManager, @_session) ->
    unless CookieManager.hasItem "accountId"
      @_showLogin()

    else
      accountId = CookieManager.getItem "accountId"
      @_signIn accountId

  _showLogin: ->
      $(".header").html "Login"
      $(".room").hide()
      $(".footer").hide()
      $(".login").show()
      $(".login .signUp").unbind "submit"
      $(".login .signUp").submit =>
        username = $(".login .signUp .username").val()
        $(".login .signUp .username").val ""
        @_signUp username

      $(".login .signIn").unbind "submit"
      $(".login .signIn").submit =>
        accountId = $(".login .signIn .accountId").val()
        $(".login .signIn .accountId").val ""
        @_signIn accountId

  _signUp: (username) ->
    @_session.accountController.signUp username, (error, accountId) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", accountId
      @_hideLogin accountId

  _signIn: (accountId) ->
    @_session.accountController.signIn accountId, (error, accountId) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", accountId
      @_hideLogin accountId

  _hideLogin: (accountId) ->
    $(".login").hide()
    $(".room").show()
    @_showFooter accountId
    @_viewManager.changeViewTo "RoomView"

  _showFooter: (accountId) ->
    $(".footer").show()
    $(".footer .accountId").html accountId
    $(".footer .logout").click =>
      $(".footer .accountId").empty()
      CookieManager.removeItem "accountId"
      @_viewManager.changeViewTo "AccountView"


module.exports = AccountView