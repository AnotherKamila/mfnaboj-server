fs = require 'fs'

config =
    ssl_options:
        key:    fs.readFileSync '../certs/server.key'
        cert:   fs.readFileSync '../certs/server.crt'
        ca:     fs.readFileSync '../certs/ca.crt'
        requestCert:        true
        rejectUnauthorized: false

    loglevel: 'info'



exports[k] = v for k, v of config
