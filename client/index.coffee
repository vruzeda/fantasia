ClientConfiguration = require "./configurations/ClientConfiguration"

console.log ClientConfiguration.serverURL
socket = io.connect ClientConfiguration.serverURL
socket.on "bla", (data) ->
  console.log "bla: #{data}"