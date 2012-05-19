# Provides helper functions for routing & responding to requests

url     = require 'url'
render  = (require './render').render


exports.resourceSet = resourceSet = []
exports.resource = (url, responses) ->
    resourceSet[url] = responses

# the actual routing function
exports.respond = (req, res) ->
    [ URL, params ] = [ url.parse(req.url).pathname, {} ] # TODO resolve templates
    return unless checkPre req, res, URL
    resourceSet[URL][req.method] req, res, params

# checks that the request can be served normally
checkPre = (req, res, URL) -> # resource does not exist
    unless resourceSet[URL]?
        render req, res, 404
        return false
    if req.method == 'OPTIONS' # respond to the OPTIONS request
        render req, res, 200, 'Allow': (allowedMethods URL).join ', '
        return false
    if req.method == 'HEAD' # HEAD is just GET without sending the body
        req.method = 'GET'; req.isHEAD = true
        return true
    unless resourceSet[URL][req.method]? # does not respond to this method
        render req, res, 405, 'Allow': (allowedMethods URL).join ', '
        return false
    return true # otherwise we're good to go

allowedMethods = (URL) ->
    allow = ['OPTIONS'] # always allowed
    if resourceSet[URL].GET? then allow.push 'HEAD' # implicitly defined by GET
    allow.push m for m of resourceSet[URL]
    return allow

exports.static = (path) ->
    # TODO rewrite to use render once render supports streams in case it is a
    # good idea
    # TODO figure out whether a mighty evil universal render function actually
    # is a good idea
    # TODO figure out whether we actually need static resources -- ever
    GET: (req, res) ->
            render req, res, 501, 'Content-Type': 'text/plain',
                   "Would serve #{path} if I could."
