
if window?.document?.createElement and window?.name != 'nodejs' # browser
  writeConsoleError = console.error.bind(console)
  writeConsoleWarn = console.warn.bind(console)
  writeConsoleInfo = console.info.bind(console)
  writeConsoleTrace = console.trace.bind(console)
  writeConsoleDebug = (console.debug or console.log).bind(console)

  formatFatalMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = 'FATAL'

    return [
      "%c  ! %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0; padding-left: 3px'
      'color: #FFF'
      'color: #FFF; background-color: #E00; padding: 0 3px'
      args...
    ]

  formatErrorMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = 'ERROR'

    return [
      "%c  ! %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0; padding-left: 3px'
      'color: #FFF'
      'color: #E00; background-color: #FDD; padding: 0 3px'
      args...
    ]

  formatWarnMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = ''

    return [
      "%c warn %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0'
      'color: #FFF'
      'color: #C63; background-color: #FFA; padding: 0 3px; margin: 0 -3px'
      args...
    ]

  formatInfoMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = ''

    return [
      "%c info %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0'
      'color: #FFF'
      'color: #5A5; font-weight: bold'
      args...
    ]

  formatDebugMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = ''

    return [
      "%cdebug %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0'
      'color: #FFF'
      'color: #999'
      args...
    ]

  formatTraceMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = ''

    return [
      "%c... %c %c#{message}"
      'color: #C0C0C0; border-right: 1px solid #D0D0D0; padding-left: 3px'
      'color: #FFF'
      'color: #AAA'
      args...
    ]

  formatSillyMessage = (message, args...) ->
    if typeof message == 'object' and message != null
      args.unshift(message)
      message = ''

    return [
      "%csilly | %c#{message}"
      'color: #C0C0C0'
      'color: #BBB'
      args...
    ]

  logFatalMessage = (args...) ->
    writeConsoleError(formatFatalMessage(args...)...)

  logErrorMessage = (args...) ->
    writeConsoleError(formatErrorMessage(args...)...)

  logWarnMessage = (args...) ->
    writeConsoleWarn(formatWarnMessage(args...)...)

  logInfoMessage = (args...) ->
    writeConsoleInfo(formatInfoMessage(args...)...)

  logDebugMessage = (args...) ->
    writeConsoleDebug(formatDebugMessage(args...)...)

  logTraceMessage = (args...) ->
    writeConsoleTrace(formatTraceMessage(args...)...)

  logSillyMessage = (args...) ->
    writeConsoleDebug(formatSillyMessage(args...)...)

else # terminal
  colorize = require 'colorize-str'
  { format } = require 'util'

  inspectValue = (value) ->
    if typeof value == 'object' and value != null
      return inspect(value)
    return String(value)

  logFatalMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D} fatal | ') +
      `'\033[41m'` + format(args...) + `'\033[0m'` +
      '\n'
    )

  logErrorMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D} error | ') +
      colorize('{#A00}' + format(args...)) +
      '\n'
    )

  logWarnMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D}  warn | ') +
      colorize('{#CB3}' + format(args...)) +
      '\n'
    )

  logInfoMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D}  info | ') +
      colorize('{#5A5}' + format(args...)) +
      '\n'
    )

  logDebugMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D} debug | ') +
      colorize('{#555}' + format(args...)) +
      '\n'
    )

  logTraceMessage = (args...) ->
    stack = new Error().stack.split('\n').slice(3).join('\n')
    process.stderr.write(
      colorize('{#2D2D2D} trace | ') +
      colorize('{#444}' + format(args...)) +
      '\n' +
      colorize('{#555}' + stack)
    )

  logSillyMessage = (args...) ->
    process.stderr.write(
      colorize('{#2D2D2D} silly | ') +
      colorize('{#333}' + format(args...)) +
      '\n'
    )


module.exports =
  install: ->
    console.silly = logSillyMessage
    console.trace = logTraceMessage
    console.debug = logDebugMessage
    console.info = logInfoMessage
    console.warn = logWarnMessage
    console.error = logErrorMessage
    console.fatal = logFatalMessage

  test: ->
    console.silly('silly message')
    console.trace('trace message')
    console.debug('debug message')
    console.info('info message')
    console.warn('warn message')
    console.error('error message')
    console.fatal('fatal message')
