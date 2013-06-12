# Models
MODELS = [
  "Account"
  "Character"
  "Exit"
  "Room"
  "Universe"
]

class ModelsIntance

  constructor: ->
    @_models = {}
    @_models[model] = require "./#{model}" for model in MODELS

  get: (model) ->
    @_models[model]


class Models

  @_instance = null

  @_getInstance: ->
    @_instance = new ModelsIntance unless @_instance?
    @_instance

  @get: (model) ->
    instance = @_getInstance()
    instance.get model


module.exports = Models