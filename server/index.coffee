express  = require "express"
http     = require "http"
socketIO = require "socket.io"

ApplicationConfigurator = require "./configurators/ApplicationConfigurator"
DatabaseConfigurator    = require "./configurators/DatabaseConfigurator"
MessagesConfigurator    = require "./configurators/MessagesConfigurator"
RoutesConfigurator      = require "./configurators/RoutesConfigurator"


application = express()
server      = http.createServer application
io          = socketIO.listen server
rootPath    = "#{__dirname}/.."
serverPort  = parseInt process.env.NODE_PORT ? 5000


applicationConfigurator = new ApplicationConfigurator rootPath
applicationConfigurator.configure application

databaseConfigurator = new DatabaseConfigurator
databaseConfigurator.configure()

messagesConfigurator = new MessagesConfigurator
messagesConfigurator.configure io

routesConfigurator = new RoutesConfigurator rootPath, serverPort
routesConfigurator.configure application



server.listen serverPort
console.log "Express server listening on port #{serverPort}"