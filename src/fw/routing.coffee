# Provides functions for defining a resource; handles routing & responding to requests
#
# Exports the `respond` function (bubbles up through export in resources) that takes the request and
# response as parameters. The server uses it to handle all incoming requests, and this function
# hands control to the appropriate controller based on the url templates defined here.
#
# URL templates
# -------------
#
# The URLs passed to `resource` can be either literal or templated with `{param-name}` as path
# components. The last template parameter can be of the form `{parameter...}`, in which case it will
# consume the whole rest of the path including other components. The template parameters will be
# passed to the handler inside an object with `req` and `res`. Literal URLs have precedence over
# templated ones. If more rules of the same precedence match, which one is called is undefined.

# TODO it would probably be a good idea to say "things that come first go first" or something
# TODO this actually is a good idea, do it tomorrow (or eventually)

url             = require 'url'
{ render, err } = require './render'

literal = {}; tokenized = {}
exports.resource = (urls, docstring, responds) ->
    responds._description = docstring
    for path in urls.split ' '
        path = sanitizedUrl path # OK to call here, just touches slashes
        if (path.indexOf '{') == -1
            literal[path] = [ responds, {} ]
        else
            [ regex, p ] = parseTokenized path
            tokenized[path] = regex: regex, responds: responds, paramsExtractor: p

# the actual routing function
exports.respond = (req, res) ->
    path      = url.parse(req.url).pathname; path = sanitizedUrl path
    respondTo = req.method; if respondTo == 'HEAD' then respondTo = 'GET'
    [ matching, params ] = literal[path] or findTokenized path
    if not matching?
        err req, res, 404; return
    if not matching[respondTo]?
        render req, res, (if respondTo == 'OPTIONS' then 200 else 405), null, 'Allow': allowedMethods(matching); return # TODO do we mind that this is not considered an error? Do I really need to separate out? :-(

    matching[respondTo] req, res, params


TokensRegex = /\{([^\/\.]+)(\.\.\.)?\}/g
parseTokenized = (path) ->
    tokens = []

    regex = path.replace TokensRegex, (_, token, greedy) ->
        tokens.push token
        if greedy then '(.*)' else '([^/]+)'
    regex = new RegExp '^' + regex + '$'

    paramsExtractor = (path) ->
        values = (path.match regex).slice 1
        params = {}; i = 0; while i < tokens.length
            params[tokens[i]] = values[i++]
        params

    [ regex, paramsExtractor ]

findTokenized = (path) ->
    for rule, p of tokenized
        if p.regex.test path
            return [ p. responds, p.paramsExtractor path ]
    [ null, null ]

allowedMethods = (responds) ->
    allow = ['OPTIONS'] # always allowed
    if responds.GET? then allow.push 'HEAD' # implicitly defined by GET
    allow.push m for m of responds
    allow

sanitizedUrl = (path) ->
    path += '/' unless path[path.length-1] == '/'
    path.replace /\/+/g, '/'
