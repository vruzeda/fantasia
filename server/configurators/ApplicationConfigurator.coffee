express = require "express"


class ApplicationConfigurator

  constructor: (@_rootPath) ->

  configure: (application) ->
    application.configure =>
      application.set "views", "#{@_rootPath}/client/html"
      application.use express.favicon()
      application.use express.logger "dev"
      application.use express.static "#{@_rootPath}/client/html"
      application.use express.bodyParser()
      application.use express.methodOverride()
      application.use application.router

    application.configure "development", ->
      application.use express.errorHandler()


module.exports = ApplicationConfigurator
