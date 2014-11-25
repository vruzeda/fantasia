coffee = require "coffee-script"
stitch = require "stitch"

Models = require "../models/Models"


class RoutesConfigurator

  constructor: (@_rootPath, @_serverAddress, @_serverPort) ->
    @_fatPackage = @_createFatPackage()

  _createFatPackage: ->
    stitch.createPackage
      paths: ["#{@_rootPath}/shared", "#{@_rootPath}/client"]
      compilers:
        stub: (module, filename) =>
          if /ClientConfiguration/.test filename
            clientConfiguration = @_clientConfiguration()
            module._compile coffee.compile(clientConfiguration), filename

  _clientConfiguration: ->
    clientConfiguration =
      serverURL: "http://#{@_serverAddress}:#{@_serverPort + 1}"

    "module.exports = #{JSON.stringify clientConfiguration}"

  configure: (application) ->
    application.get  "/login",        @_login
    application.post "/signUp",       @_signUp
    application.post "/signIn",       @_signIn

    application.get  "/",             @_index
    application.get  "/fatPack.js",   @_fatPackage.createServer()

  _login: (request, response) =>
    response.render "login"

  _signUp: (request, response, next) =>
    Account = Models.get "Account"
    Account.create request.body.username, request.body.password
    .then (account) ->
      response.send account.id
    .fail (error) ->
      response.status(400).send error.message

  _signIn: (request, response, next) =>
    Account = Models.get "Account"
    Account.login request.body.username, request.body.password
    .then (account) ->
      response.send account.id
    .fail (error) ->
      response.status(400).send error.message

  _index: (request, response) =>
    response.render "index"


module.exports = RoutesConfigurator
