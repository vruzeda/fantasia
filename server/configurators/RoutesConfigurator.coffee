stitch = require "stitch"
coffee = require "coffee-script"

LoginService = require "../services/login/LoginService"


class RoutesConfigurator

  constructor: (@_clientPath, @_serverPort) ->
    @_fatPackage = @_createFatPackage()

  _createFatPackage: ->
    stitch.createPackage
      paths: ["#{@_clientPath}"]
      compilers:
        stub: (module, filename) =>
          console.log "filename: #{filename}"

          if /ClientConfiguration/.test filename
            clientConfiguration = @_clientConfiguration()
            module._compile coffee.compile(clientConfiguration), filename

  _clientConfiguration: ->
    clientConfiguration =
      serverURL: "http://localhost:#{@_serverPort}"

    "module.exports = #{JSON.stringify clientConfiguration}"

  configure: (application) ->
    application.get  "/",             @_index
    application.get  "/fatPack.js",   @_fatPackage.createServer()
    application.post "/login/signUp", @_signUp
    application.post "/login/signIn", @_signIn

  _index: (request, response) =>
    response.render "index",
      title: "Hello, world!"

  _signUp: (request, response) =>
    username = request.body.username
    password = request.body.password

    LoginService.signUp username, password, (error) ->
      if error?
        response.render "error",
          title: "Sign Up Error"
          error: error

      else
        response.render "index",
          title: "Hello, #{username}!"
          username: username

  _signIn: (request, response) =>
    username = request.body.username
    password = request.body.password

    LoginService.signIn username, password, (error) ->
      if error?
        response.render "error",
          title: "Sign In Error"
          error: error

      else
        response.render "index",
          title: "Hello, #{username}!"
          username: username


module.exports = RoutesConfigurator