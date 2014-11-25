CookieManager = require "../controllers/CookieManager"

$(".login .signUp").submit (event) ->
  event.preventDefault();

  username = $(".login .signUp .username").val()
  password = $(".login .signUp .password").val()
  $.post "/signUp", {username, password}
  .done (accountId) ->
    CookieManager.setItem "accountId", accountId
    window.location = "/"
  .fail (response) ->
    console.error response.responseText

$(".login .signIn").submit (event) ->
  event.preventDefault();

  username = $(".login .signIn .username").val()
  password = $(".login .signIn .password").val()
  $.post "/signIn", {username, password}
  .done (accountId) ->
    CookieManager.setItem "accountId", accountId
    window.location = "/"
  .fail (response) ->
    console.error response.responseText
