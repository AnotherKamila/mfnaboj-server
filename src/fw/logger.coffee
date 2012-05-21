fs = require 'fs'

loglevels =
    fatal: 0
    error: 1
    warn:  2
    info:  3
mylevel = (require '../conf').loglevel; if typeof mylevel == 'string' then mylevel = loglevels[mylevel]
ansicolors =
    0:  '\033[41m\033[1;37m\033[1m'
    1:  '\033[31m\033[1m'
    2:  '\033[33m'
    3:  '\033[32m'
    off:'\033[0m'

timestamp = -> new Date()
Date.prototype.toTimestamp = ->
    "#{this.getFullYear()}/#{this.getMonth()+1}/#{this.getDate()} #{this.toLocaleTimeString()}"

exports.createLogger = (filename) ->
    logfile = fs.createWriteStream filename, flags: 'a'
    logger = {}
    logger.log = (level, message, context) ->
        if typeof level == 'string' then level = loglevels[level]
        return if level > mylevel
        e = level: level, timestamp: timestamp().toTimestamp(), message: message, context: context
        logfile.write (JSON.stringify e) + '\n'
        console.log "#{ansicolors[level]}[#{e.timestamp}] #{e.message}#{ansicolors.off}"

    for level of loglevels # -> logger.info(), logger.warn(), ...
        do (level) -> logger[level] = (message, context) -> logger.log level, message, context

    logger.console = (message) ->
        console.log "[#{(new Date()).toTimestamp()}] #{message}"

    logger
