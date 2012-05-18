exports.route =	(req, res) ->
		res.writeHead 200, 'Content-Type': 'text/plain'
		if req.client.authorized
			certdata = req.client.encrypted.getPeerCertificate().subject
			res.write "authorized for scope: #{certdata.ST}/#{certdata.L}\n"
		else
			res.write 'unauthorized user\n'
		res.end '\n'
