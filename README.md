#Jaadi

Jaadi is simple, easy to use, abstraction API over many storage techniques provided by DOM, W3C, Browser specific (Chrome) and user defined storages. Jaadi provides interface for basic CRUD operations.

##How to get it?

You can download the latest version of [jaadi from the build/ folder](build/js/jaadi-1.0.js). Standard Jaadi implementation gives access to following storage implementations

* Browser DOM's default property map `{}`
* Browser Cookie `document.cookies`
* W3C's `window.localStorage`
* W3C's `window.sessionStorage`
* Chrome's `chrome.storage.local`


##API Usage

Jaadi provides these basic CRUD methods

* get
* put
* remove
* size
* items

### Usage

    var dom = Jaadi.createInstance("dom")

### put (key,value)
create an entry into the storage

    dom.put("a",10);    //put a literal
    dom.put("person", {name:"Name","age":10});  //put a JSON


### get(key)
get the item from storage using the keys

    var val = dom.get("a");
    var person = dom.get("person"); //get back a JSON object


### remove(key)
remove the entry from storage

    dom.remove("person");   //remove the person object


### items()
Returns the dom elements as pair `(key,value)`. This follows the python's items() construct which returns the list of items.

    var items = dom.items(); //get the items as set 
    for(var i = 0; i < items.length;i++)
    {
    key = items[i][0];
    value = items[i][1];
        console.log("Key="+key+" Value=" + value);
    }


### size
Returns the count of items in the storage

    var count = dom.size(); //size of the Jaadi

### Writing Plugins

Jaadi allows you to create your own storage extension and use it across your app. Extend the basic class and write your own storage plugin. 

All the storage mechanisms are created as plugins. Refer to [src/](src/) folder for `.jaadi.js` files

Add plugin to Jaadi

    Jaadi.plugins.add("bst",BinarySearchTree);


Use it

    tree = Jaadi.createInstance("bst");

### Additional plugins

Jaadi provides a simple Binary search tree implementation. You can [download the plugin](build/js/bst.jaadi.js).


### Supported plugins

* Browser DOM's default property map `{}`
* Browser Cookie `document.cookies`
* W3C's `window.localStorage`
* W3C's `window.sessionStorage`
* Chrome's `chrome.storage.local`
* Simple Binary tree implementation