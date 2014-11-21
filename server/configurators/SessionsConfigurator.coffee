Controllers = require "../controllers/Controllers"


class SessionsConfigurator

  configure: (serverPort) ->
    SessionManager = Controllers.get("SessionManager")
    SessionManager.configure serverPort


module.exports = SessionsConfigurator
