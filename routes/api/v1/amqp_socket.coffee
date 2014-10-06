WebSocketServer = require('ws').Server
amqp = require('../../../lib/amqp')

module.exports = class AmqpSocket
  exchanges: [
    "door.entry"
    "statistics.power"
    "statistics.bandwidth"
    "eight"
  ]

  constructor: (@server, @path) ->
    console.log "connecting?"
    # Initialize the AMQP connection
    amqp.on 'ready', @_onAmqpReady
    amqp.on 'error', @_onError
    # Initialize the websocket server
    @wss = new WebSocketServer
      server: @server
      path: @path
      protocolVersion: 8
    @wss.on 'connection', @_onConnection

  _onError: (e) =>
    console.log arguments

  _onAmqpReady: =>
    # Set up the queues
    @setup_queue k for k in @exchanges

  setup_queue: (k) -> amqp.queue "#{k}.hapi", (q) =>
    console.log "AMQP: Connected to #{k}.hapi queue"
    q.bind k, "#"
    q.subscribe @_onAmqpMessage

  _onAmqpMessage: (message, headers, deliveryInfo, messageObject) =>
    console.log "AMQP: Recieved #{deliveryInfo.queue} message"
    console.log "AMQP: #{message.data.toString()}"
    @broadcast
      queue: deliveryInfo.queue
      message: JSON.parse message.data.toString()

  broadcast: (data) ->
    data = JSON.stringify data
    ws.send(data) for ws in @wss.clients

  _onConnection: (ws) =>
    ws.on 'message', @_onMessage
    @broadcast(test: 'something')

  _onMessage: (data) ->
    console.log(data)
