$ = require "../libs/jquery"

CookieManager = require "../controllers/CookieManager"


class AccountView

  constructor: (@_session) ->
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
        password = $(".login .signUp .password").val()
        $(".login .signUp .password").val ""
        @_signUp username, password

      $(".login .signIn").unbind "submit"
      $(".login .signIn").submit =>
        accountId = $(".login .signIn .accountId").val()
        $(".login .signIn .accountId").val ""
        @_signIn accountId

  _signUp: (username, password) ->
    @_session.accountController.signUp username, password, (error, account) =>
      if error?
        alert error.message
        return

      CookieManager.setItem "accountId", account.id
      @_hideLogin account

  _signIn: (accountId) ->
    @_session.accountController.signIn accountId, (error, account) =>
      if error?
        CookieManager.removeItem "accountId"
        @_showLogin()
        return

      CookieManager.setItem "accountId", account.id
      @_hideLogin account

  _hideLogin: (account) ->
    @_showHeader account
    @_showFooter account
    $(".login").hide()
    $(".room").show()
    @_session.viewManager.changeViewTo "RoomView"

  _showHeader: (account) ->
    $(".header").show()
    $(".header").html "Welcome, #{account.username}"

  _showFooter: (account) ->
    $(".footer").show()
    $(".footer .accountId").html account.id
    $(".footer .helpButton").click ->
      $(".helpContainer").show "linear", ->
        $("body").click ->
          $(".helpContainer").hide "linear", ->
            $("body").unbind "click"

    $(".footer .logout").click =>
      $(".footer .accountId").empty()
      CookieManager.removeItem "accountId"
      @_session.viewManager.changeViewTo "AccountView"


module.exports = AccountView
