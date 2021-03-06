bodyParser         = require "body-parser"
express            = require "express"
errorhandler       = require "errorhandler"
methodOverride     = require "method-override"
morgan             = require "morgan"
serveStatic        = require "serve-static"

RoutesConfigurator = require "./RoutesConfigurator"


class ApplicationConfigurator

  constructor: (@_rootPath, @_serverAddress, @_serverPort) ->

  configure: (application) ->
    application.set "views", "#{@_rootPath}/client/html"
    application.set "view engine", "hbs"
    application.use morgan "dev"
    application.use serveStatic "#{@_rootPath}/client/html", { index: false }
    application.use bodyParser.urlencoded { extended: false }
    application.use bodyParser.json()
    application.use methodOverride()

    routesConfigurator = new RoutesConfigurator @_rootPath, @_serverAddress, @_serverPort
    routesConfigurator.configure application

    if process.env.NODE_ENV == "development"
      application.use errorhandler()


module.exports = ApplicationConfigurator
