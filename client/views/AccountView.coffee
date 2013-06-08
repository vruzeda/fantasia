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
    @_session.accountController.signUp username, (error, account) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", account.id
      @_hideLogin account

  _signIn: (accountId) ->
    @_session.accountController.signIn accountId, (error, account) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", account.id
      @_hideLogin account

  _hideLogin: (account) ->
    @_showHeader account
    @_showFooter account
    $(".login").hide()
    $(".room").show()
    @_viewManager.changeViewTo "RoomView"

  _showHeader: (account) ->
    $(".header").show()
    $(".header").html "Welcome, #{account.name}"

  _showFooter: (account) ->
    $(".footer").show()
    $(".footer .accountId").html account.id
    $(".footer .logout").click =>
      $(".footer .accountId").empty()
      CookieManager.removeItem "accountId"
      @_viewManager.changeViewTo "AccountView"


module.exports = AccountView