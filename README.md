#Jaadi

Jaadi is simple, standard abstraction API over many storage techniques provided by DOM, W3C, Browser specific (Chrome) and user defined storages. Jaadi provides interface for basic CRUD operations.

##How to get it?

You can download the latest version of jaadi here. Here is a [working sample of Jaadi](http://www.maheshsubramaniya.com/projects/jaadi-sample.html).

##API Usage

Jaadi provides these basic CRUD methods

* get
* put
* remove
* size
* items

### Usage

    var dom = Container.createInstance("dom")

### put (key,value)
create an entry into the storage
<pre>
    dom.put("a",10);    //put a literal
    dom.put("person", {name:"Name","age":10});  //put a JSON
</pre>

### get(key)
get the item from storage using the keys

    var val = dom.get("a");
    var person = dom.get("person"); //get back a JSON object


### remove(key)
remove the entry from storage

    dom.remove("person");   //remove the person object


### items()
Returns the dom elements as pair `(key,value)`. This follows the python's items() construct which returns the set

    var items = dom.items(); //get the items as set 
	for(var i = 0; i < items.length;i++)
	{
        key = items[i][0];
        value = items[i][1];
		console.log("Key="+key+" Value=" + value);
	}


### size
Returns the count of items in the storage
    var count = dom.size(); //size of the container
### Writing Plugins

Jaadi allows you to create your own storage extension and use it across your app. Extend the basic class and write your own storage plugin.

#### Create a BinarySearchTree storage

<pre>
    class BinarySearchTree extends JaadiPlugin
		class Node
			constructor: () ->
				@left = @right = null
				@value = null

			hash: () -> @value

		constructor: () ->	
			@root = new Node()

		put: (index,value) ->
			# do binary search and place the value

		get: (index) ->
			# do binary search and get the value
			return @container[index];

		remove: (index) ->
			# remove the value from BSI

		items: () ->
			#do dfs and prepare items
</pre>

Add plugin to Jaadi

    Container.plugins.add("bst",BinarySearchTree);


Use it

    tree = Container.createInstance("bst");


#### Using an Array via CRUD methods


    class ArrayStorage extends JaadiPlugin
    	constructor: () ->	@container = []
    	put: (index,value) ->
    		@container[index] = value;
    	get: (index) ->
    		return @container[index];
    	remove: (index) ->
    		@container = @container.splice(index,1);
    

Add plugin to Jaadi

    Container.plugins.add("array",ArrayStorage);

Use it

    arr = Container.createInstance("array");


### Supported plugins

* DOM's default property map `{}`
* W3C's `window.localStorage`
* Chrome's `chrome.storage.local`
