###
Storage plugin for Chrome Local Storage object
###

class ChromeLocalStoragePlugin extends JaadiPlugin
    constructor : () ->
        @storage = chrome.storage.local
    get: (key) ->   JSON.parse @storage.get(key)
    put: (key,value) ->   @storage.put(key,JSON.stringify value)
    remove: (key) ->   @storage.remove(key)
    size: () -> @storage.length

###
Storage plugin for W3C DOM Local Storage object
###

class W3CStoragePlugin extends JaadiPlugin
    constructor : (@storage) ->
    get: (key) ->   JSON.parse @storage.getItem(key)
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