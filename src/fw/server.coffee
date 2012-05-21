# Provides the server, which handles SSL and some request logging

https  = require 'https'
fs     = require 'fs'
logger = (require './logger').createLogger '/tmp/mfnaboj-server.access.log'

# starts the server
#
# respond: the request handler (will receive request & response objects)
exports.start = (respond, port) ->
    https.createServer (require '../conf').ssl_options, (req, res) ->
            respond req, res
            logger.info "#{if req.client.authorized then "⌂" else "·"} #{req.method} #{req.url} → #{res.statusCode}"
        .listen port

    logger.console "** https server started on port #{port} **"
