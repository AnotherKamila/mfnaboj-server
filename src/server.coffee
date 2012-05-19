https = require 'https'
fs	  = require 'fs'

options =
	key:	fs.readFileSync '../certs/server.key'
	cert:	fs.readFileSync '../certs/server.crt'
	ca:		fs.readFileSync '../certs/ca.crt'
	requestCert: 		true
	rejectUnauthorized: false

server = null

# starts the server
#
# route: function that returns a request handler based on the request url
exports.start = (respond, port) ->
	server = https.createServer options, (req, res) ->
			console.log "#{if req.client.authorized then "⌂" else "·"} #{req.method} #{req.url}"
			respond req, res
			console.log "  → #{res.statusCode}"
		.listen port

	console.log "** https server started on port #{port} **"
	console.log ''

exports.stop = ->
	server.close()
	console.log '** server stopped **'

# TODO use a dedicated logger instead of console.log
