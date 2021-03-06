express = require('express')
path = require('path')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
cors = require('cors')

TeghDiscoveryAmqp = require('./lib/tegh_discovery_amqp')
new TeghDiscoveryAmqp()

apiRoutes = require('./routes/api/v1/index')

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')


# enable CORS!
# app.use('/api/v1/', enableCORS)

app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded extended: false)
# app.use(cookieParser())
# app.use(require('stylus').middleware(path.join(__dirname, 'public')))
# app.use(express.static(path.join(__dirname, 'public')))

# Adding traditional routes
app.use('/api/v1/', apiRoutes)

# enable CORS!
app.use(cors)

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status(err.status || 500)
    # res.render 'error', message: err.message, error: err
    res.send message: err.message, error: err


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status(err.status || 500)
  res.send message: err.message, error: {}


module.exports = app
