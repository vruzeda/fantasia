BaseCommandView = require "./BaseCommandView"
CookieManager   = require "../controllers/CookieManager"


class RoomView extends BaseCommandView

  constructor: (@_session, account) ->
    super @_session

    @_edit = false
    @_showRoom account
    @_showFooter()

    @_session.roomController.getCurrentRoom (error, room) =>
      if error?
        alert error.message
        return

      @drawRoom room

  drawRoom: (room) ->
    $(".room .title").html room.name
    $(".room .title").blur (event) =>
      @_session.commandController.executeCommand "rename room #{$(event.currentTarget).text()}"

    $(".room .description").html room.description.replace /([^.!?])$/, "$1."
    $(".room .description").blur (event) =>
      @_session.commandController.executeCommand "describe room #{$(event.currentTarget).text()}"

    if room.exits?
      exits = (exit.direction for exit in room.exits)

      exitsHtml
      switch exits.length
        when 0
          exitsHtml = ""
        when 1
          exitsHtml = "You see an exit at #{@_getExitHTML exits[0]}."
        else
          exitsHtml = "You see exits at "
          for exit, index in exits[0..-2]
            exitsHtml += ", " if index > 0
            exitsHtml += @_getExitHTML exit
          exitsHtml += " and #{@_getExitHTML exits[exits.length - 1]}."

      $(".room .exits").html exitsHtml
      @_bindExits()

  _showRoom: (account) ->
    $(".room").show()
    $(".room .header").html "Welcome, #{account.username}"

  _showFooter: ->
    $(".footer").show()

    $(".footer .edit").click =>
      @_toogleEdit()

    $(".footer .helpButton").click ->
      $(".help").show "linear", ->
        $("body").click ->
          $(".help").hide "linear", ->
            $("body").off "click"

    $(".footer .logout").click =>
      CookieManager.removeItem "accountId"
      @_showLogin()

  _toogleEdit: ->
    @_edit = not @_edit
    $(".room .title").prop "contenteditable", @_edit
    $(".room .title").toggleClass "form-control", @_edit
    $(".room .description").prop "contenteditable", @_edit
    $(".room .description").toggleClass "form-control", @_edit
    @_bindExits()

  _bindExits: ->
    $(".room .exits .roomLink").prop "contenteditable", @_edit
    $(".room .exits .roomLink").toggleClass "form-control", @_edit
    $(".room .exits .roomLink").off "blur"
    $(".room .exits .roomLink").off "click"

    if @_edit
      $(".room .exits .roomLink").blur (event) =>
        oldExitName = $(event.currentTarget).find(".oldExit").val()
        newExitName = $(event.currentTarget).text()
        @_session.commandController.executeCommand "rename exit #{oldExitName}:#{newExitName}" if oldExitName != newExitName

    else
      $(".room .exits .roomLink").click (event) =>
        @_session.commandController.executeCommand "go #{$(event.currentTarget).text()}"


  _showLogin: ->
    $(".room").hide()
    $(".footer").hide()
    @_session.viewManager.changeViewTo "AccountView"

  _getExitHTML: (exit) ->
    "<a class=\"roomLink\" href=\"javascript:void(0);\"><input class=\"oldExit\" type=\"hidden\" value=\"#{exit}\"></input>#{exit}</a>"


module.exports = RoomView
