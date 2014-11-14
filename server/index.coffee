express  = require "express"
http     = require "http"

ApplicationConfigurator = require "./configurators/ApplicationConfigurator"
DatabaseConfigurator    = require "./configurators/DatabaseConfigurator"
SessionsConfigurator    = require "./configurators/SessionsConfigurator"
RoutesConfigurator      = require "./configurators/RoutesConfigurator"


application = express()
server      = http.createServer application
rootPath    = "#{__dirname}/.."
serverPort  = parseInt process.env.NODE_PORT ? 5000


applicationConfigurator = new ApplicationConfigurator rootPath
applicationConfigurator.configure application

databaseConfigurator = new DatabaseConfigurator
databaseConfigurator.configure()

sessionsConfigurator = new SessionsConfigurator
sessionsConfigurator.configure server

routesConfigurator = new RoutesConfigurator rootPath, serverPort
routesConfigurator.configure application



server.listen serverPort
console.log "Express server listening on port #{serverPort}"
