express = require('express')
db      = require("../../../lib/db")
tegh    = require("tegh-client-node")
eight   = require("../../../lib/eight")

weather = require("../../../lib/weather")

# news    = new require("../../../lib/news")

router = express.Router()
module.exports = router

router.get '/card_events', (req, res, next) ->
  query =
    "select c.card_id, c.user, c.nick, a.entry_count, a.logged " +
    "from (select aa.id, aa.logged, aa.card_id, ab.entry_count from access_log aa " +
    "join (select card_id, count(*) as entry_count from access_log group by card_id) ab " +
    "on aa.card_id = ab.card_id ORDER BY aa.id DESC) as a " +
    "join card c ON a.card_id = c.card_id ORDER BY a.id DESC"

  db.query query, [], (e, results) ->
    if e?
      res.status(500).send error: e
    else
      res.json results.rows
    next()

router.get '/weather', (req, res) ->
  res.json weather.json()

router.get '/news', (req, res) ->
  res.json news.json()

router.get '/tegh-printers', (req, res) ->
  res.json tegh.discovery.services

router.get '/eight', (req, res) ->
  res.json eight.eight()
