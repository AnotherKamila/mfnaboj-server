# Collects info about all existing resources.
# 
# Exports the `respond` function that takes the request and response as
# parameters. The server uses it to handle all incoming requests, and this
# function hands control to the appropriate controller based on the url templates
# defined here.

render  = (require './render').render
helpers = require './routing_helpers'
[ resource, resSet, exports.respond ] = [ helpers.resource, helpers.resourceSet, helpers.respond ]

resource '/',
    GET:    (req, res) ->
                if req.client.authorized
                    crtdata = req.client.encrypted.getPeerCertificate().subject
                    body = "authorized for scope: #{crtdata.ST}/#{crtdata.L}\n"
                else
                    body = 'unauthorized user\n'

                render req, res, 200, 'Content-Type': 'text/plain', body

resource '/hello/{name}',
    GET:    (req, res, params) ->
                render req, res, 200, 'Content-Type': 'text/plain',
                       "Hello #{if params.name? then params.name else 'World'}\n"

    PUT:    (req, res) ->
                if req.client.authorized
                    render req, res, 501, 'Content-Type': 'text/plain',
                           "I Would PUT if I could, but I can't, so I shan't.\n"
                else
                    render req, res, 401, 'Content-Type': 'text/plain',
                           'Unauthorized! Boo!'


resource '/assets/{path}', (req, res, p) -> helpers.static 'assets/' + p.path

resource '*', {} # for OPTIONS (may be used as a no-op according to RFC1626 :D)
