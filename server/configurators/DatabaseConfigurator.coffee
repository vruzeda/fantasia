mongoose = require "mongoose"


models = [
  "../models/Account"
]


class DatabaseConfigurator

  configure: ->
    mongoose.connect "mongodb://localhost/wikimud"
    mongoose.connection.once "open", ->
      require model for model in models


module.exports = DatabaseConfigurator