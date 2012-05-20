# Collects info about all existing resources.
#
# This is the "what" of the service: defines what it can do

{ render, err }       = require './fw/render'
{ resource, respond } = require './fw/routing'
naboj                 = require './naboj'
exports.respond = respond

# For all resources one can access a specific language version either by setting the
# `Accept-Language` header, or by adding the `lang=[2-letter code]` query parameter

# **THIS IS ALL WRONG AND WILL CHANGE** as apparently it would be much better if I could provide
# guarantees about what happens if there are more matches, as that would remove the need to have
# orthogonal url templates. Therefore I am going to do it that way and rewrite the schema.
# Meanwhile I'd like feedback on whether this is complete.

resource '/',
         'Provides general info and lists all contests',
         GET:   (req, res) -> err req, res, 501 # TODO

resource '/{contest} /{contest}/info', # the special value 'current' for {contest} is supported
         'Info about the contest',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO
                    # info = naboj.contestInfo params['contest-name'] or null
                    # if not info? then err req, res, 404 else render req, res, 200, info
         PUT:   (req, res, params) ->
                    err req, res, 501 # TODO
                    # if req.client.authorized and req.client.encrypted.getPeerCertificate().subject. # TODO NOW

resource '/{contest}/{state}/info /{contest}/{state}/{city}/info', # to add contest locality PUT to .../info :-/ (alt: POST to /contest?)
         'Places where the contest occurs',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO
         PUT:   (req, res, params) ->
                    err req, res, 501 # TODO

resource '/{contest}/teams /{contest}/{state}/teams /{contest}/{state}/{city}/teams',
         # accepts additional restrictions as query parameters;
         # special values 'all' and 'current' for {contest} are supported
         'List of teams',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO
         # Depending on whether teams will have a generated ID, a POST might be here

resource '/{contest}/{state}/{city}/teams/{team}',
         # the special values 'all' and current' for {contest} are supported (or maybe just current depending on how unique team IDs will be)
         'Info about the given team',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO
         # Depending on whether teams will have a generated ID, a PUT might be here

resource '/{contest}/results /{contest}/{state}/results /{contest}/{state}/{city}/results',
         # accepts additional restrictions as query parameters;
         # the special value 'current' for {contest} is supported
         'Competition results',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO

resource '/{contest}/problems',
         # uses the `Accept` header or `format` query parameter to serve a specific format (pdf, tex, ...)
         # the special value 'current' for {contest} is supported
         'List of problems',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO

resource '/{contest}/problems/{number}',
         # uses the `Accept` header or `format` query parameter to serve a specific format (pdf, tex, ...)
         # the special value 'current' for {contest} is supported
         'The given problem',
         GET:   (req, res, params) ->
                    err req, res, 501 # TODO

# offtopic stuff follows ===========================================================================

resource '/serverstatus',
         'In case someone not on IRC would like to know :P', # note: yes, the server will talk over IRC ^^
         GET:   (req, res) ->
                    err req, res, 501, TODO: naboj.TODO

resource '/authtest', # This one's actually implemented! But I don't know what `priv` means yet...
         'Tests authorization',
         GET:   (req, res) ->
                    if req.client.authorized
                        crtdata = req.client.encrypted.getPeerCertificate().subject
                        body = authorized: true, priv: crtdata.OU, scope: "#{crtdata.ST}/#{crtdata.L}"
                    else
                        body = authorized: false

                    render req, res, 200, body

resource '/wtf',
         'check whether custom http status codes get through',
         GET:   (req, res) -> err req, res, 601, wtf: 'TMF!' # yes, time to start...

resource '*', 'RFC2616 mentions OPTIONS at * as a no-op (OPTIONS are automatic)', {}
resource '/ping', 'an alternative no-op (but this one responds to GET)', GET: (req, res) -> render req, res, 200
