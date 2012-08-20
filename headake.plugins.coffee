
util = require 'util'
colors = require 'colors'
fs = require 'fs'
file = require 'file'
path = require 'path'

makeOutDir = (opts = {}) ->
	out = opts.rule.out(opts.matches)
	outDir = path.dirname(out)
	file.mkdirsSync(outDir)
	return out

module.exports =
	
	echo:
		run: (opts = {}) ->
			console.log 'echoing ' + opts.filename
			return 0
	
	coffeescript:
		run: (opts = {}) ->
			try
				CoffeeScript = require 'coffee-script'
				out = makeOutDir(opts)
				source = fs.readFileSync(opts.filename).toString()
				rendered = CoffeeScript.compile source, opts.pluginOpts
				fs.writeFileSync(out, rendered)
				return 0
			catch err
				util.error err.toString().red
				return 1
	
	jade:
		run: (opts = {}) ->
			try
				jade = require 'jade'
				out = makeOutDir(opts)
				source = fs.readFileSync(opts.filename).toString()
				renderer = jade.compile source, opts.pluginOpts
				rendered = renderer()
				fs.writeFileSync(out, rendered)
				return 0
			catch err
				util.error err.toString().red
				return 1
	
	stylus:
		run: (opts = {}) ->
			try
				out = makeOutDir(opts)
				stylus = require 'stylus'
				source = fs.readFileSync(opts.filename).toString()
				status = 0
				s = stylus(source)
				s.set('filename', opts.filename)
				for method, args of opts.pluginOpts
					args = [args] unless util.isArray(args)
					s[method].apply(s, args)
				s.render( (err, css) ->
					if err
						status = 1
						throw err
					fs.writeFileSync(out, css)
				)
				return status
			catch err
				util.error err.toString().red
				return 1
	
		
