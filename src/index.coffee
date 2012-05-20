# The "main()" of this service
#
# Puts the "what" to life: Launches the server with the appropriate `respond`
# function.

# TODO add try/catch everywhere

resources = require './resources'
server    = require './server'

server.start resources.respond, 4443
