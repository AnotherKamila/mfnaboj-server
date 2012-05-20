# Provides helper functions for routing & responding to requests

url     = require 'url'
render  = (require './render').render

literal = {}; tokenized = {}
exports.resource = (urls, responds) ->
    for path in urls.split ' '
        if (path.indexOf '{') == -1
            literal[path] = [ responds, {} ]
        else
            [ regex, p ] = parseTokenized path
            tokenized[path] = regex: regex, responds: responds, paramsExtractor: p

# the actual routing function
exports.respond = (req, res) ->
    path   = url.parse(req.url).pathname
    method = req.method; if method == 'HEAD' then method = 'GET'
    [ matching, params ] = literal[path] or findTokenized path
    if not matching?
        render req, res, 404; return
    if not matching[method]?
        render req, res, (if method == 'OPTIONS' then 200 else 405), 'Allow': allowedMethods(matching); return

    matching[method] req, res, params

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
            params[tokens[i]] = values[i]
            i++ # oops :D
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
