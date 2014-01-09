###
A basic jaadi plugin 
###
class JaadiPlugin
    constructor : (@storage={}) ->

    get: (key) ->
    put: (key,value) ->
    remove: (key) ->
    size:  () ->
    clear: () ->
    items: () ->
        _items = []
        for key,val of @_storage
            _items.push([key,val])
        return _items

    parseJSON: (item) ->
        try
            JSON.parse item
        catch
            null

class Jaadi

    ###
        default javascript DOM storage implementation
    ###
    class DomStoragePlugin extends JaadiPlugin
        constructor : () ->
            @_container = {}
        get: (key) -> @_container[key]
        put: (key,value) -> @_container[key] = value
        remove: (key) -> delete @_container[key]
        size: () ->
            length = 0
            console.log @_container
            for key,val of @_container
                length++
            return length
        items: () ->
            _items = []
            for key,val of @_container
                _items.push([key,val])
            return _items

    @createInstance = (name) =>
        try
            jaadiType = @plugins.get(name)

            # if there is no name attribute, then it is not a class. It may be a function which decides the class on the fly #
            
            if '__super__' of jaadiType # it is a class to instantiate
                jaadiType = new jaadiType
            else if( typeof(jaadiType) is "function" )   # a method to decide if it is a class or not
                jaadiType = jaadiType.call()
        catch
            throw "Implementation #{name} not available"
            #jaadiType = new DomStoragePlugin()

        return jaadiType

    @plugins = new DomStoragePlugin()
    @plugins.add = (key,value) -> this.put(key,value)

    # add some default plugins
    
    # Add the DOM storage
    @plugins.add("dom",DomStoragePlugin)