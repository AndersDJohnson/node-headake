node-headake
============

A pluggable, simple build tool using Node.js. No more headaches!

Provides a plugin mechanism to simplify and [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) common compilation tasks. See [Plugins](#plugins) below for supported plugins.

Works well with [Cake][cake]. Inspired in part by [Muffin][muffin].

Usage
---

Here is a (fake) usage example written in CoffeeScript:

```coffeescript
headake.run({
	files:
		# map file patterns (RegExp strings) to rule defintions

		'some/regex/pattern/(.*)\.coffee':
			
			plugin: 'a_plugin_name', # the name of a plugin
			opts: {
				# plugin options, usually passed to plugin's compiler
			},

			# below, 'matches' is return value of RegExp.exec() on matching file path
			out: (matches) ->
				# return an output file path
				return 'some/output/directory/' + matches[1] + '.js'

			ignore: (matches) ->
				# return true to ignore file, despite match
				return path.basename(matches[0]).indexOf('_') is 0
		
		###
		...more pattern-to-rule mappings...
		###
		
})
```

See [/examples] for more realistic use cases.

Plugins
-------
Currently supporting:

* [CoffeeScript][coffeescript]
* [Jade][jade]
* [Stylus][stylus]

...and more on the way! Feel free to fork & pull request your own plugins!


[cake]: http://coffeescript.org/documentation/docs/cake.html "Cake"
[coffeescript]: http://coffeescript.org/ "CoffeeScript"
[jade]: http://jade-lang.com/ "Jade"
[stylus]: http://learnboost.github.com/stylus/ "Stylus"
[muffin]: https://github.com/hornairs/muffin "Muffin"
