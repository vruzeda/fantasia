Controllers = require "../controllers/Controllers"


class SessionsConfigurator

  configure: (server) ->
    SessionManager = Controllers.get("SessionManager")
    SessionManager.configure server


module.exports = SessionsConfigurator