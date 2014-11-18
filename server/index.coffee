express  = require "express"
http     = require "http"

ApplicationConfigurator = require "./configurators/ApplicationConfigurator"
DatabaseConfigurator    = require "./configurators/DatabaseConfigurator"
SessionsConfigurator    = require "./configurators/SessionsConfigurator"


application   = express()
server        = http.createServer application
rootPath      = "#{__dirname}/.."
serverAddress = process.env.NODE_ADDRESS ? "localhost"
serverPort    = parseInt process.env.NODE_PORT ? 5000


applicationConfigurator = new ApplicationConfigurator rootPath, serverAddress, serverPort
applicationConfigurator.configure application

databaseConfigurator = new DatabaseConfigurator
databaseConfigurator.configure()

sessionsConfigurator = new SessionsConfigurator
sessionsConfigurator.configure server



server.listen serverPort
console.log "Express server listening on port #{serverPort}"
