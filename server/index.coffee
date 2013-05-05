express  = require "express"
http     = require "http"
socketIO = require "socket.io"

HandlebarsConfigurator  = require "./configurators/HandlebarsConfigurator"
ApplicationConfigurator = require "./configurators/ApplicationConfigurator"
RoutesConfigurator      = require "./configurators/RoutesConfigurator"
MessagesConfigurator    = require "./configurators/MessagesConfigurator"


application = express()
server      = http.createServer application
io          = socketIO.listen server
clientPath  = "#{__dirname}/../client"
serverPort  = parseInt process.env.NODE_PORT ? 5000

handlebarsConfigurator = new HandlebarsConfigurator
handlebarsConfigurator.configure()

applicationConfigurator = new ApplicationConfigurator clientPath
applicationConfigurator.configure application

routesConfigurator = new RoutesConfigurator clientPath, serverPort
routesConfigurator.configure application

messagesConfigurator = new MessagesConfigurator
messagesConfigurator.configure io

server.listen serverPort
console.log "Express server listening on port #{serverPort}"