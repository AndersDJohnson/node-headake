
util = require 'util'
colors = require 'colors'
fs = require 'fs'
file = require 'file'
path = require 'path'

path.sep ?= '/'

headake = exports

headake.plugins ?= require './headake.plugins'

successes = []
errors = []
ignores = []

log = (opts) ->
	plugin = ('[' + opts.plugin + ']').cyan
	pluginAndFiles = plugin + ' "' + opts.files + '"'
	if opts.status is 0
		util.puts ('ok'.green + ' ' + pluginAndFiles)
		successes.push opts
	else if opts.status is 1
		util.puts ('oops'.red + ' ' + pluginAndFiles)
		errors.push opts
	else if opts.status is -1
		util.puts ('no plugin'.red + ' ' + pluginAndFiles)
		errors.push opts
	else if opts.status is -2
		util.puts ('ignore'.yellow + ' ' + pluginAndFiles)
		ignores.push opts
		

headake.run = (opts = {}) ->
	opts.files ?= {}
	opts.rootDir ?= '.'
	
	util.puts.apply null, [
		'==========='.rainbow
		'| headake | '.rainbow
		'==========='.rainbow
		''
	]
	
	start = new Date()
	
	for pattern, rule of opts.files
		pluginName = rule.plugin
		plugin = exports.plugins[pluginName]
		unless plugin?
			log {status: -1, plugin: pluginName, files: pattern}
			util.puts('')
		else
			regexp = new RegExp(pattern)
			file.walkSync opts.rootDir, (dirPath, dirs, files) ->
				if files?.length?
					for filename in files
						joined = path.join(opts.rootDir, dirPath, filename)
						matches = regexp.exec(joined)
						unless matches?
							continue
						else if rule.ignore? and rule.ignore(matches)
							log {status: -2, plugin: pluginName, files: joined}
						else
							pluginOpts = rule.pluginOpts
							status = plugin.run({
								filename: joined
								rule: rule
								matches: matches
								runOpts: opts
								pluginOpts: pluginOpts
							})
							log {status: status, plugin: pluginName, files: joined}
						util.puts('')
	
	finish = new Date()
	
	took = finish.getTime() - start.getTime()
		
	util.puts.apply null, [
		 '================'.grey
		 ' done!'.grey
		(' ok:    ' + successes.length).green
		(' oops:  ' + errors.length).red
		(' n/a:   ' + ignores.length).yellow
		(' time:  ' + took + ' ms').grey
		 '================'.grey
	]


