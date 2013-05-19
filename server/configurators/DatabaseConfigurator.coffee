mongoose = require "mongoose"


models = [
  "../models/Account"
]


class DatabaseConfigurator

  configure: ->
    mongoose.connect "mongodb://localhost/fantasia"
    mongoose.connection.once "open", ->
      require model for model in models


module.exports = DatabaseConfigurator