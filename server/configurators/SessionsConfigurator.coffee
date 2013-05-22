SessionManager = require "../controllers/SessionManager"


class SessionsConfigurator

  configure: (server) ->
    SessionManager.configure server


module.exports = SessionsConfigurator