node-headake
============

A pluggable, simple build tool using Node.js. No more headaches!

Provides a plugin mechanism to simplify and [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) common compilation tasks. See [Plugins](#plugins) below for supported plugins.

Works well with [Cake][cake]. Inspired in part by [Muffin][muffin].

If this proves to be useful, I intend to package it via [npm][npm].


Usage
---

Here is a (fake) usage example written in CoffeeScript:

```coffeescript

headake = require 'path/to/headake'
path = require 'path'

headake.run({
	files:
		# map your file patterns to rule defintions
		#  e.g. 'RegExp string': { /* rule */ }
		
		'some/regex/pattern/(.*)\.coffee':
			
			plugin: 'a_plugin_name'
			opts: {
				# plugin options, usually passed to plugin's compiler
			},

			# 'matches' parameter comes from RegExp.exec() on matching file path
			out: (matches) ->
				return 'some/output/directory/' + matches[1] + '.js'  # same basename as source

			# return true to ignore a matching file
			ignore: (matches) ->
				return path.basename(matches[0]).indexOf('_') is 0  # don't compile underscore-prefixed files
		
		###
		...more pattern-to-rule mappings...
		###
		
})
```

See [examples][examples] for more realistic use cases.

Plugins
-------
Currently supporting:

* [CoffeeScript][coffeescript]
* [Jade][jade]
* [Stylus][stylus]

...and more on the way!

Feel free to fork & pull request your own plugins!


[examples]: https://github.com/AndersDJohnson/node-headake/tree/master/examples "Examples"
[cake]: http://coffeescript.org/documentation/docs/cake.html "Cake"
[coffeescript]: http://coffeescript.org/ "CoffeeScript"
[jade]: http://jade-lang.com/ "Jade"
[stylus]: http://learnboost.github.com/stylus/ "Stylus"
[muffin]: https://github.com/hornairs/muffin "Muffin"
[npm]: https://npmjs.org/ "npm"
