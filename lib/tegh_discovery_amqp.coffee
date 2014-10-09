amqp = require('./amqp')
tegh = require('tegh-client-node')

module.exports = class TeghDiscoveryAmqp
  constructor: ->
    tegh.discovery
    .on("serviceUp",   @_onServiceUp)
    .on("serviceDown", @_onServiceDown)
    .start()

    amqp.on 'ready', @_onAmqpReady

  _onServiceUp: (service) =>
    @exchange.publish "tegh.service.up",   service if @exchange?

  _onServiceDown: (service) =>
    @exchange.publish "tegh.service.down", service if @exchange?

  _onAmqpReady: => amqp.exchange "tegh.services", type: "fanout", (@exchange) =>
    console.log "AMQP: Connected to tegh.services exchange"
    @_onServiceUp service for service in tegh.discovery.services
