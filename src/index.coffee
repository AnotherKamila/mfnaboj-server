# The "`main()`" of this service
#
# Puts the "what" to life: Launches the server with the appropriate `respond`
# function.

# TODO add try/catch --> 500 everywhere once we have proper logging

resources = require './resources'
server    = require './fw/server'

server.start resources.respond, 4443
