# Exports `render`, a function that actually renders the response.
# ###TODO:
# - this will be templated one day
# - this will look into the Accept header one day
# - this will correctly handle both objects and strings/buffers/streams as body 
#	one day
exports.render = (req, res, status, headers, body) ->
	status  ?= 200
	headers ?= {}
	res.writeHead status, headers
	res.write body + '\n' if body
	res.end()
