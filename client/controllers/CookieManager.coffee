class CookieManagerInstance

  getItem: (key) ->
    escapedKey = escape key
    escapedKey = escapedKey.replace /[\-\.\+\*]/g, "\\$&"

    cookieRegex = new RegExp "(?:(?:^|.*;)\\s*#{escapedKey}\\s*\\=\\s*([^;]*).*$)|^.*$"

    cookie  = document.cookie
    cookie  = cookie.replace cookieRegex, "$1"
    cookie ?= null

  setItem: (key, value, end, path, domain, secure) ->
    return false unless key? and not /^(?:expires|max\-age|path|domain|secure)$/i.test key

    if end?
      switch end.constructor
        when Number
          expires = "; max-age=#{end}"
          expires = "; expires=Fri, 31 Dec 9999 23:59:59 GMT" if end == Infinity
        when String
          expires = "; expires=#{end}"
        when Date
          expires = "; expires=#{end.toGMTString()}"

    cookie  = "#{escape key}=#{escape value}"
    cookie += "; #{expires}"       if expires?
    cookie += "; domain=#{domain}" if domain?
    cookie += "; path=#{path}"     if path?
    cookie += "; secure"           if secure

    document.cookie = cookie

  removeItem: (key, path) ->
    return false unless key? and @hasItem key

    cookie = "#{escape key}=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (sPath ? "; path=" + sPath : "");
    cookie = "; path=#{path}" if path?

    document.cookie = cookie
    true

  hasItem: (key) ->
    escapedKey = escape key
    escapedKey = escapedKey.replace /[\-\.\+\*]/g, "\\$&"

    cookieRegex = new RegExp "(?:^|;\\s*)#{escapedKey}\\s*\\="
    cookieRegex.test document.cookie

  keys: ->
    keys = document.cookie.replace /((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, ""
    keys = keys.split /\s*(?:\=[^;]*)?;\s*/
    (unescape key for key in keys)


class CookieManager

  @_instance = null

  @_getInstance: ->
    @_instance = new CookieManagerInstance unless @_instance?
    @_instance

  @getItem: (key) ->
    instance = @_getInstance()
    instance.getItem key

  @setItem: (key, value, end, path, domain, secure) ->
    instance = @_getInstance()
    instance.setItem key, value, end, path, domain, secure

  @removeItem: (key, path) ->
    instance = @_getInstance()
    instance.removeItem key, path

  @hasItem: (key) ->
    instance = @_getInstance()
    instance.hasItem key

  @keys: ->
    instance = @_getInstance()
    instance.keys()


module.exports = CookieManager