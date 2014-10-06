amqp = require('./amqp')

class Eight
  constructor: ->
    amqp.on 'ready', @_onAmqpReady

  _onAmqpReady: => amqp.exchange "eight", type: "fanout", (@exchange) =>
    console.log "AMQP: eight"

  # 8
  eight: =>
    @exchange.publish "eight", eight: 8

module.exports = new Eight()