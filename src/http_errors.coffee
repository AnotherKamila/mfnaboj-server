renderError = (status, message, res) ->
	res.writeHead status, 'Content-Type': 'text/plain'
	res.end message + '\n'

err = []

err[404] = (req, res) -> renderError 404, "The page you requested (#{req.url}) could not be found.", res

exports.err = err
