AMQP = require('amqp')

module.exports = AMQP.createConnection
  host: "moa.hacklab.to"
  login: process.env.AMQP_LOGIN
  password: process.env.AMQP_PASSWORD

