url     = require 'url'
err		= (require './http_errors').err

exports.resourceSet = resourceSet = []
exports.resource = (url, responses) ->
	resourceSet[url] = responses

exports.respond = (req, res) ->
		resolvedURL = url.parse(req.url).pathname # TODO
		if resourceSet[resolvedURL]?
			if req.method == 'OPTIONS'
				respondOptions resolvedURL, res
			else
				resourceSet['/'].GET req, res
		else
			err[404] req, res

respondOptions = (resolvedURL, res) ->
	allow = ['OPTIONS']
	if resourceSet[resolvedURL].GET? then allow.push 'HEAD'
	allow.push m for m of resourceSet[resolvedURL]
	res.writeHead 200, 'Allow': allow.join ', '
	res.end()


exports.static = (path) ->
	GET: (req, res) ->
			res.writeHead 501, 'Content-Type': 'text/plain'
			res.write "Would serve #{path} if I could.\n"
			res.end()
