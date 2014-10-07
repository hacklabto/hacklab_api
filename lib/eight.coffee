amqp = require('./amqp')

class Eight
  constructor: ->
    amqp.on 'ready', @_onAmqpReady

  _onAmqpReady: => amqp.exchange "eight", type: "fanout", (@exchange) =>
    console.log "AMQP: eight"

  # 8
  eight: =>
    message = eight: 8
    @exchange.publish "eight", message
    return message

module.exports = new Eight()