#!/usr/bin/env node
var path = require('path');
var fs   = require('fs');
var root  = path.join(path.dirname(fs.realpathSync(__filename)), '../');


// Coffeescript 1.0 and 2.0 respectively. Comment out the one you aren't using.
require('coffee-script/register');
// require('coffee-script-redux/register');

var app = require(path.join(root, "app"));
var port = process.env.NODE_PORT || 3000;
process.env.NODE_PORT = port;


require('figaro').parse("./figaro.json", function() {
  var server = app.listen(port, function() {
    // Adding socket route
    AmqpSocket = require(path.join(root,'./routes/api/v1/amqp_socket'));
    new AmqpSocket(server, '/api/v1/amqp-socket');
    console.log('Listening on port %d', server.address().port);
  });
});