# Exports `render`, a function that renders an object into a JSON response and sends it, plus err

# pre:  body is an object without circular references
# post: response has been sent
exports.render = (req, res, status, body, headers) ->
    status  ?= 200
    headers ?= {}
    headers['Content-Type'] = 'application/json'
    if status == 601 then res.writeHead 601, 'WTF', headers else res.writeHead status, headers
    res.write JSON.stringify body if body and not req.isHEAD
    res.end()

# for now; later this should include some awesome logging
exports.err = exports.render
