
test("Jaadi default storage tests",function(){


	notEqual(Jaadi.createInstance("localstorage"),null)
	notEqual(Jaadi.createInstance("dom"),null)

	/* verify if the base class JaadiPlugin is available to use and extend */
	notEqual(typeof(JaadiPlugin),"undefined")
	equal("name" in JaadiPlugin,true)

	/* check if inbuilt plugins works */
	j = Jaadi.createInstance("dom")
	notEqual(j,null)

	/* verify all the basic functions are available */
	fns = ["get","put","size","remove"]
	for(var i = 0; i < fns.length; i++)
	{
		equal(typeof(j[fns[i]]),"function")	
	}

	/* add 1 element */
	j.put("a",1);
	equal(j.get("a"),1)	;
	equal(j.size(),1);
	
	/* add 1  more element */
	j.put("b",2);
	equal(j.get("b"),2)	;
	equal(j.size(),2);

	/* add 1  more element */
	j.remove("b");
	equal(j.get("b"),null)	;
	equal(j.size(),1);
})

test('Test creating a custom plugin',function(){
	/* create a custom Storage plugin */
	TestLocalStoragePlugin = (function(_super) {
	  __extends(TestLocalStoragePlugin, _super);

	  function TestLocalStoragePlugin() {}

	  TestLocalStoragePlugin.prototype.get = function(key) {
	    return 0;
	  };

	  TestLocalStoragePlugin.prototype.put = function(key, value) {
	    return 0;
	  };

	  TestLocalStoragePlugin.prototype.remove = function(key) {
	    return 0;
	  };

	  TestLocalStoragePlugin.prototype.size = function() {
	    return 0;
	  };

	  return TestLocalStoragePlugin;

	})(JaadiPlugin);

	/* add the plugin to the container */
	Jaadi.plugins.add("teststore",TestLocalStoragePlugin);
	equal(Jaadi.createInstance("teststore") instanceof TestLocalStoragePlugin,true)

	j1 = Jaadi.createInstance("teststore");
	notEqual(j1,null);
	equal(j1 instanceof TestLocalStoragePlugin,true)

	/* all operations will return 0 */
	equal(j1.get("a"),0);
	equal(j1.put("b",100),0);
	equal(j1.get("a"),0);
	equal(j1.size(),0);
	equal(j1.remove("a"),0);
	equal(j1.size(),0);

})

test('Test web localstorage',function(){
	/* test localStorage capabilities */
	local = Jaadi.createInstance("localstorage")
	local.clear(); //clear area before start testing
	equal(local instanceof W3CLocalStoragePlugin,true)
	local.put("a",1);
	equal(local.get("a"),1)	;
	equal(local.size(),1);
	
	/* add 1  more element */
	local.put("b",2);
	equal(local.get("b"),2)	;
	equal(local.size(),2);

	/* add 1  more element */
	local.remove("b");
	equal(local.get("b"),null)	;
	equal(local.size(),1);	

	/* add 1  more element */
	local.put("person", {name:"Name","age":10});  //put a JSON
	equal(JSON.stringify(local.get("person")),JSON.stringify({name:"Name","age":10}));
	
	//wipeout storage
	local.clear(); //clear area before start testing
	equal(local.size(),0);



})

test('Test web sessionstorage',function(){
	/* test localStorage capabilities */
	session = Jaadi.createInstance("session")
	session.clear(); //clear storage

	equal(session instanceof W3CSessionStoragePlugin,true)
	session.put("a",1);
	equal(session.get("a"),1)	;
	equal(session.size(),1);
	
	/* add 1  more element */
	session.put("b",2);
	equal(session.get("b"),2)	;
	equal(session.size(),2);

	/* add 1  more element */
	session.remove("b");
	equal(session.get("b"),null)	;
	equal(session.size(),1);	

	/* add 1  more element */
	session.put("person", {name:"Name","age":10});  //put a JSON
	equal(JSON.stringify(session.get("person")),JSON.stringify({name:"Name","age":10}));
	session.remove("person");

})

test('Test BinarySearchTree',function(){


	bst = Jaadi.createInstance("bst");
	equal(bst instanceof BinarySearchTree,true)

	/* populate data */
	_ref = [["k", 1], ["m", 2], ["a", 3], ["d", 4]];
	for (v = _i = 0, _len = _ref.length; _i < _len; v = ++_i) {
		k = _ref[v];
		bst.put(k[0], k[1]);
	}

	equal(bst.get("k"),1);
	equal(bst.size(),4);
	
	/* add 1  more element */
	//bst.remove("b");
	equal(bst.get("d"),4);

	items = bst.items();
	order = [["a", 3], ["d", 4],["k", 1], ["m", 2]];
	equal(JSON.stringify(items),JSON.stringify(order))
})