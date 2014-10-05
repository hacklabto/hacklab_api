mysql = require('db-mysql')
opts =
  hostname: process.env.DB_HOST
  user: process.env.DB_USER
  database: process.env.DB_DATABASE

db = new mysql.Database(opts)

module.export = (cb) ->
  if module.export.ready
    setImmediate -> cb(db)
  else
    db.on 'ready', -> cb(db)

module.export.connection = db
module.export.ready = false

db
.on('error', (error) ->
  console.log('ERROR: ' + error)
  process.exit()
.on('ready', (server) ->
  console.log("Connected to #{server.hostname} (#{server.version})")
  module.export.ready = true
.connect()
