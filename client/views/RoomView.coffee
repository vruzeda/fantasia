BaseCommandView = require "./BaseCommandView"
CookieManager   = require "../controllers/CookieManager"


class RoomView extends BaseCommandView

  constructor: (@_session, account) ->
    super @_session

    @_edit = false
    @_showRoom account
    @_showNavBarActions()

    @_session.roomController.getCurrentRoom (error, @_room) =>
      if error?
        alert error.message
        return

      @drawRoom @_room

  drawRoom: (room) ->
    $(".room .title .content").html room.name
    $(".room .title .content").blur (event) =>
      @_session.commandController.executeCommand "rename room #{$(event.currentTarget).text()}"

    $(".room .description .content").html room.description.replace /([^.!?])$/, "$1."
    $(".room .description .content").blur (event) =>
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

  _showNavBarActions: ->
    $(".navbaractions .edit").click =>
      @_toggleEdit()

    $(".navbaractions .exit").click =>
      CookieManager.removeItem "accountId"
      @_session.viewManager.changeViewTo "AccountView"

  _showRoom: (account) ->
    $(".room .header").html "Welcome, #{account.username}"

    $(".help.btn").click ->
      $(".help.btn").toggleClass "active"
    $(".help.btn").popover
      placement: "top"
      trigger: "click"
      title: "Available commands"
      content: $(".help.popover").html()
      html: true

  _toggleEdit: ->
    @_edit = not @_edit
    $(".navbaractions .edit").parent().toggleClass "active", @_edit
    $(".room .title .content").prop "contenteditable", @_edit
    $(".room .title .content").toggleClass "form-control", @_edit
    $(".room .description .content").prop "contenteditable", @_edit
    $(".room .description .content").toggleClass "form-control", @_edit
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
        if oldExitName != newExitName
          @_session.commandController.executeCommand "rename exit #{oldExitName}:#{newExitName}"
        else
          @drawRoom @_room

    else
      $(".room .exits .roomLink").click (event) =>
        @_session.commandController.executeCommand "go #{$(event.currentTarget).text()}"

  _getExitHTML: (exit) ->
    "<a class=\"roomLink\" href=\"javascript:void(0);\"><input class=\"oldExit\" type=\"hidden\" value=\"#{exit}\"></input>#{exit}</a>"


module.exports = RoomView
