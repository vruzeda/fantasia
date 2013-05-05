class LoginServiceInstance

  signUp: (username, password, callback) ->
    console.log "Sign up: #{username}, #{password}"
    callback null

  signIn: (username, password, callback) ->
    console.log "Sign in: #{username}, #{password}"
    callback null


class LoginService

  @_instance = null

  @_getInstance: ->
    @_instance = new LoginServiceInstance unless @_instance?
    @_instance

  @signUp: (username, password, callback) ->
    instance = @_getInstance()
    instance.signUp username, password, callback

  @signIn: (username, password, callback) ->
    instance = @_getInstance()
    instance.signIn username, password, callback


module.exports = LoginService