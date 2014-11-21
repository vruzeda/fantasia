Session = require "../controllers/Session"

# Views
VIEWS = [
  "AccountView"
  "RoomView"
]


class ViewManager

  constructor: ->
    @_initializeSession()
    @_initializeViews()

    @changeViewTo "AccountView"

  _initializeSession: ->
    @_session = new Session @

  _initializeViews: ->
    @_views = {}
    @_views[viewName] = require "./#{viewName}" for viewName in VIEWS

  changeViewTo: (viewName, data...) ->
    @currentView = new @_views[viewName] @_session, data...


module.exports = ViewManager
