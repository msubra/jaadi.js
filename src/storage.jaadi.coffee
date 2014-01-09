###
Storage plugin for Chrome Local Storage object
###

class ChromeLocalStoragePlugin extends JaadiPlugin
    constructor : () ->
        @storage = chrome.storage.local
    get: (key) ->   @parseJSON @storage.get(key)
    put: (key,value) ->   @storage.put(key,JSON.stringify value)
    remove: (key) ->   @storage.remove(key)
    size: () -> @storage.length

###
Storage plugin for W3C DOM Local Storage object
###

class W3CStoragePlugin extends JaadiPlugin
    constructor : (@storage) ->
    get: (key) ->   @parseJSON @storage.getItem(key)
    put: (key,value) ->  @storage.setItem(key,JSON.stringify value)
    remove: (key) ->   @storage.removeItem(key)
    size: () -> @storage.length
    clear: () ->
        for k,v of @storage
            @remove(k)

class W3CLocalStoragePlugin extends W3CStoragePlugin
    constructor : () ->
        super(window.localStorage)

class W3CSessionStoragePlugin extends W3CStoragePlugin
    constructor : () ->
        super(window.sessionStorage)

###
Interface for cookie storage
###
class CookieStoragePlugin extends JaadiPlugin

    ###
        Mozilla License
        https://developer.mozilla.org/en-US/docs/DOM/document.cookie
        * docCookies.setItem(name, value[, end[, path[, domain[, secure]]]])
        * docCookies.getItem(name)
        * docCookies.removeItem(name[, path], domain)
        * docCookies.hasItem(name)
        * docCookies.keys()
    ###

    docCookies = 
      getItem: (sKey) ->
        return decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null;
      
      setItem: (sKey, sValue, vEnd, sPath, sDomain, bSecure) ->
        
        return false if !sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey) 

        sExpires = "";
        if vEnd
          switch (vEnd.constructor)
            when Number
              sExpires = vEnd == Infinity ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + vEnd;
              break;
            when String
              sExpires = "; expires=" + vEnd;
              break;
            when Date
              sExpires = "; expires=" + vEnd.toUTCString();
              break;
          

        document.cookie = encodeURIComponent(sKey) + "=" + encodeURIComponent(sValue) + sExpires + (sDomain ? "; domain=" + sDomain : "")   + (sPath ? "; path=" + sPath : "") + (bSecure ? "; secure" : "");

        return true;
      
      removeItem: (sKey, sPath, sDomain) ->
        return false if (!sKey || !this.hasItem(sKey))
        
        document.cookie = encodeURIComponent(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + ( sDomain ? "; domain=" + sDomain : "") + ( sPath ? "; path=" + sPath : "");

        return true;
      
      hasItem: (sKey) ->
        return (new RegExp("(?:^|;\\s*)" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=")).test(document.cookie);
      
      keys: () ->
        
        aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/);

        nIdex = 0
        for key in aKeys
            nIdx = nIdx + 1
            aKeys[nIdx] = decodeURIComponent(key);

        return aKeys;

    constructor : () ->
        @storage = Jaadi.createInstance("dom")

        cookies = document.cookie.split( ';' )

        for cookie in cookies
            if cookie
                tokens = cookie.split("=")
                cookie_name = tokens[0].replace(/^\s+|\s+$/g, '');
                cookie_value = tokens[1]

                @storage.put cookie_name,cookie_value

    get: (key) ->
        @parseJSON @storage.get(key)
    
    put: (key,value) ->  
        console.log @storage.items()
        # store in the DOM storage
        @storage.put(key,JSON.stringify value)

        #sync the cookie jar. if cookies doesnt exists, then create one
        docCookies.setItem(key,value)

    remove: (key) ->   
        
        #delete item from cookie
        docCookies.removeItem(key)

        #sync the local container
        @storage.remove(key)

    size: () -> 
        @storage.size()

    clear: () ->
        @storage.clear()
        # clear all the cookies for the domain

# Browser Local Storage
Jaadi.plugins.add("localstorage",()->
    
    try
        # check if W3C localStorage is available
        window.localStorage         #chrome should throw error for this

        if not window["locplugin"]  # always return singleton instance
            window["locplugin"] = new W3CLocalStoragePlugin()
    catch
        if(chrome and chrome.storage?)
            if not window["locplugin"]  # always return singleton instance
                window["locplugin"] = new ChromeLocalStoragePlugin();

    return window["locplugin"]
)

# Browser Session Storage
Jaadi.plugins.add("session",()->
    
    try
        # check if W3C localStorage is available
        window.sessionStorage         #chrome should throw error for this

        if not window["sessplugin"]  # always return singleton instance
            window["sessplugin"] = new W3CSessionStoragePlugin()
        return window["sessplugin"]
    catch
        throw "sessionStorage not supported"
)

Jaadi.plugins.add("cookie",()->

    if not window["cookieplugin"]  # always return singleton instance
        window["cookieplugin"] = new CookieStoragePlugin()

    return window["cookieplugin"]
)