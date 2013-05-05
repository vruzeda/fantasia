express    = require "express"
http       = require "http"


application = express()

application.configure ->
  application.set "views", "#{__dirname}/../client/views"
  application.set "view engine", "hbs"
  application.use express.favicon()
  application.use express.logger "dev"
  application.use express.static "#{__dirname}/../client/views"
  application.use express.bodyParser()
  application.use express.methodOverride()
  application.use application.router

application.configure "development", ->
  application.use express.errorHandler()

application.get "/", (request, response) ->
  response.render "index", title: "Hello, world!"


serverPort = parseInt process.env.NODE_PORT ? 5000
http.createServer(application).listen(serverPort)
console.log "Express server listening on port #{serverPort}"