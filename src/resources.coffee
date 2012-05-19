helpers = require './routing_helpers'
[ resource, resSet, exports.respond ] = [ helpers.resource, helpers.resourceSet, helpers.respond ]

resource '/',
	GET: 	(req, res) ->
				res.writeHead 200, 'Content-Type': 'text/plain'
				if req.client.authorized
					certdata = req.client.encrypted.getPeerCertificate().subject
					res.write "authorized for scope: #{certdata.ST}/#{certdata.L}\n"
				else
					res.write 'unauthorized user\n'
				res.end '\n'


resource '/hello/{name}',
	GET:	(req, res, params) ->
				res.writeHead 200, 'Content-Type': 'text/plain'
				res.write "Hello #{if params.name? then params.name else 'World'}!\n"
				res.end()

	PUT:	(req, res) ->
				if req.client.authorized
					res.writeHead 501, 'Content-Type': 'text/plain'
					res.write 'Would PUT if I could, but I can\'t, so I shan\'t.\n'
				else
					res.writeHead 401, 'Content-Type': 'text/plain'
					res.write 'Unauthorized! Boo!'
				res.end()


resource '/assets/{path}', (req, res, p) -> helpers.static 'assets/' + p.path

resource '*', {} # for OPTIONS (may be used as a no-op according to RFC1626 :D)
