# Controllers
CONTROLLERS = [
  "AccountController"
  "CommandController"
  "RoomController"
  "SessionManager"
]

class ControllersIntance

  constructor: ->
    @_controllers = {}
    @_controllers[controller] = require "./#{controller}" for controller in CONTROLLERS

  get: (controller) ->
    @_controllers[controller]


class Controllers

  @_instance = null

  @_getInstance: ->
    @_instance = new ControllersIntance unless @_instance?
    @_instance

  @get: (controller) ->
    instance = @_getInstance()
    instance.get controller


module.exports = Controllers