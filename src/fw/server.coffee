# Provides the server, which handles SSL and some request logging

# TODO proper logging (detailed for errors; to file; async -> req & res must be together)

https  = require 'https'
fs     = require 'fs'
logger = (require './logger').createLogger '/tmp/mfnaboj-server.access.log'

options =
    key:    fs.readFileSync '../certs/server.key'
    cert:   fs.readFileSync '../certs/server.crt'
    ca:     fs.readFileSync '../certs/ca.crt'
    requestCert:        true
    rejectUnauthorized: false

# starts the server
#
# respond: the request handler (will receive request & response objects)
exports.start = (respond, port) ->
    https.createServer options, (req, res) ->
            respond req, res
            logger.info "#{if req.client.authorized then "⌂" else "·"} #{req.method} #{req.url} → #{res.statusCode}"
        .listen port

    logger.console "** https server started on port #{port} **\n"
