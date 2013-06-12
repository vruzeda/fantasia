class CountdownLatch

  constructor: (@_steps, config) ->
    @_success = config.success ? ->
    @_error   = config.error   ? ->

    @_currentStep = 0
    @_haveError = false
    @_checkConclusion()

  step: ->
    @_currentStep++
    @_checkConclusion()

  _checkConclusion: ->
    @_success() if @_currentStep >= @_steps

  error: (error) ->
    unless @_haveError
      @_haveError = true
      @_error error


module.exports = CountdownLatch