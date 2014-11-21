coffee = require "coffee-script"
stitch = require "stitch"


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
    application.get "/",             @_index
    application.get "/fatPack.js",   @_fatPackage.createServer()

  _index: (request, response) =>
    response.render "index"


module.exports = RoutesConfigurator
