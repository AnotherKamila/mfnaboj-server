# Exports `render`, a function that actually renders the response.
# ###TODO:
# - this will be templated one day
# - this will look into the Accept header one day and serialize accordingly
# - this will correctly handle both objects and strings/buffers/streams as body
#	one day
exports.render = (req, res, status, headers, body) ->
	status  ?= 200
	if typeof headers == 'string' then [body, headers] = [headers, null] # someone left out headers probably
	headers ?= {}
	res.writeHead status, headers
	res.write body + '\n' if body and not req.isHEAD # TODO read the TODO on lines 4 and 5
	res.end()

# for now; later this should include some awesome logging
exports.err = exports.render
