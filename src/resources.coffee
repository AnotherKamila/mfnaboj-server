# Collects info about all existing resources.
#
# This is the "what" of the service: defines what it can do
#
# Exports the `respond` function that takes the request and response as
# parameters. The server uses it to handle all incoming requests, and this
# function hands control to the appropriate controller based on the url
# templates defined here.
#
# URL templates
# -------------
#
# The URLs defined here can be either literal or templated with `{param-name}`
# as path components. The last template parameter can be of the form
# `{parameter...}`, in which case it will consume the whole rest of the path
# including other components. The template parameters will be passed to the
# handler in an object as the 3rd parameter along with `req` and `res`.
# Literal URLs have precedence over templated ones. If more rules of the same
# precedence match, which one is called is undefined.

{ render, err }       = require './fw/render'
{ resource, respond } = require './fw/routing'
exports.respond = respond

resource '/',
    GET:    (req, res) ->
                if req.client.authorized
                    crtdata = req.client.encrypted.getPeerCertificate().subject
                    body = "authorized for scope: #{crtdata.ST}/#{crtdata.L}\n"
                else
                    body = 'unauthorized user\n'

                render req, res, 200, 'Content-Type': 'text/plain', body


resource '*', {} # for OPTIONS (may be used as a no-op according to RFC1626 :D)
    # TODO maybe should be implemented as a special case? (e.g. to make it
    # faster, and also keep it in the framework to avoid forgetting to put it
    # here)
