class BinarySearchTree extends JaadiPlugin
	class Entry
		constructor: (@key,@value) ->
		hash: () -> @key

	class Node
		constructor: (@left=null,@right=null,@value=null) ->
		hash: () -> @value

	constructor: () ->	
		@root = null

	_insert = (node,entry) ->
		if entry.key < node.value.key
			if node.left == null
				node.left = new Node(null,null,entry)
			else
				_insert(node.left,entry)
		else
			if node.right == null
				node.right = new Node(null,null,entry)
			else
				_insert(node.right,entry)

	put: (key,value) ->
		if @root is null
			@root = new Node(null,null,new Entry(key,value))
		else
			_insert @root,new Entry(key,value)

	get: (key) ->
		val = null
		dfs = (node,search) ->
			return null if node is null
			if node.value.key == search.key
				return node.value
			else if search.key < node.value.key
				return dfs(node.left,search)
			else
				return dfs(node.right,search)

		val = dfs(@root,new Entry(key,null))
		return val.value

	remove: (index) ->
		throw "Not impelemented"

	size : () -> 
		count = 0
		dfs = (node) ->
			return if node is null
			dfs(node.left)
			count++
			dfs(node.right)

		dfs(@root)
		return count

	items: () ->
		_items = []
		dfs = (node) ->
			return if node is null
			dfs(node.left)
			_items.push([node.value.key,node.value.value])
			dfs(node.right)

		dfs @root
		return _items

	dfs: (fn) ->
		_dfs = (node,fn) =>

			if node == null
				return

			_dfs(node.left,fn)
			fn.call(@this,node)
			_dfs(node.right,fn)

		_dfs(@root,fn)

Jaadi.plugins.add("bst",BinarySearchTree)
