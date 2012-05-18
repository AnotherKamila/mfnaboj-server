routes = require './routes'
server = require './server'

# port = (require 'process').argv[1] or 4443
port = 4443

server.start routes.route, port
