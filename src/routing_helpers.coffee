url     = require 'url'
render	= (require './render').render

exports.resourceSet = resourceSet = []
exports.resource = (url, responses) ->
	resourceSet[url] = responses

exports.respond = (req, res) ->
		resolvedURL = url.parse(req.url).pathname # TODO
		if resourceSet[resolvedURL]?
			if req.method == 'OPTIONS'
				respondOptions req, res, resolvedURL
			else
				resourceSet['/'].GET req, res
		else
			render req, res, 404

respondOptions = (req, res, resolvedURL) ->
	allow = ['OPTIONS']
	if resourceSet[resolvedURL].GET? then allow.push 'HEAD'
	allow.push m for m of resourceSet[resolvedURL]
	render req, res, 200, 'Allow': allow.join ', '


exports.static = (path) ->
	# TODO rewrite to use render once render supports streams in case it is a
	# good idea
	# TODO figure out whether a mighty evil universal render function actually
	# is a good idea
	# TODO figure out whether we actually need static resources -- ever
	GET: (req, res) ->
			res.writeHead 501, 'Content-Type': 'text/plain'
			res.write "Would serve #{path} if I could.\n"
			res.end()
