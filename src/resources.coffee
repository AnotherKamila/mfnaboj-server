# Collects info about all existing resources.
#
# This is the "what" of the service: defines what it can do

{ render, err }       = require './fw/render'
{ resource, respond } = require './fw/routing'
exports.respond = respond

resource '/',
         'Tests authorization (for now)',
         GET:   (req, res) ->
                    if req.client.authorized
                        crtdata = req.client.encrypted.getPeerCertificate().subject
                        body = "authorized for scope: #{crtdata.ST}/#{crtdata.L}\n"
                    else
                        body = 'unauthorized user\n'

                    render req, res, 200, 'Content-Type': 'text/plain', body

resource '*',
         'RFC2616 mentions OPTIONS at * as a no-op (OPTIONS are automatic)',
         {}

resource '/serverstatus',
         'In case someone not on IRC would like to know :P' # note: yes, the server will talk over IRC ^^
