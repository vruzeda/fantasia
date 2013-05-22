Session       = require "./controllers/Session"
CookieManager = require "./controllers/CookieManager"


session = new Session

if CookieManager.hasItem "accountId"
  console.log "accountId = #{CookieManager.getItem "accountId"}"

else
  session._accountController.signIn "519d3fa74b4de74a73000001", (error, accountId) ->
    CookieManager.setItem "accountId", accountId