stitch = require "stitch"
coffee = require "coffee-script"


class RoutesConfigurator

  constructor: (@_clientPath, @_serverPort) ->
    @_fatPackage = @_createFatPackage()

  _createFatPackage: ->
    stitch.createPackage
      paths: ["#{@_clientPath}"]
      compilers:
        stub: (module, filename) =>
          if /ClientConfiguration/.test filename
            clientConfiguration = @_clientConfiguration()
            module._compile coffee.compile(clientConfiguration), filename

  _clientConfiguration: ->
    clientConfiguration =
      serverURL: "http://localhost:#{@_serverPort}"

    "module.exports = #{JSON.stringify clientConfiguration}"

  configure: (application) ->
    application.get "/",           @_index
    application.get "/fatPack.js", @_fatPackage.createServer()

  _index: (request, response) =>
    response.render "index"


module.exports = RoutesConfigurator