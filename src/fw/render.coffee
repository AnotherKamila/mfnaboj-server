# Exports `render`, a function that renders an object into a JSON response and sends it, plus err

logger = (require './logger').createLogger '/tmp/mfnaboj-server.error.log'

# pre:  body is an object without circular references
# post: response has been sent
exports.render = (req, res, status = 200, body, headers = {}) ->
    headers['Content-Type'] = 'application/json'
    res.writeHead status, headers
    res.write JSON.stringify body if body and req.method != 'HEAD'
    res.end()

# for now; later this should include some awesome logging
exports.err = (req, res, status = 500, body, headers = {}) ->
    headers['Content-Type'] = 'application/json'
    if status == 601 then res.writeHead 601, 'WTF', headers else res.writeHead status, headers
    res.write JSON.stringify body if body and req.method != 'HEAD'
    switch status
        when 404 then logger.warn  "status #{status} for: #{req.method} #{req.url}"
        when 501 then logger.error "status #{status} - Not implemented: #{req.method} #{req.url}"
        when 601 then logger.fatal "WTF: #{req.method} #{req.url}",
            auth: if req.client.authorized then req.client.encrypted.getPeerCertificate().subject else null
        else logger.warn "error #{status} for: #{req.method} #{req.url}"
    res.end()

