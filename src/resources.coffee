url = require 'url'

resources = []

resource = (url, respondsTo) ->
	resources[url] = respondsTo

exports.respond = (req, res) ->
	# TODO :D
	resources['/'].GET req, res


resource '/',
	'GET': 	(req, res) ->
				res.writeHead 200, 'Content-Type': 'text/plain'
				if req.client.authorized
					certdata = req.client.encrypted.getPeerCertificate().subject
					res.write "authorized for scope: #{certdata.ST}/#{certdata.L}\n"
				else
					res.write 'unauthorized user\n'
				res.end '\n'
