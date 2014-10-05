FeedSub = require('feedsub')
db = require("./db")

module.exports = class News
  interval: 60*1000 # Update the news once every minute
  maxArticles: 10

  constructor: ->
    @articles = []
    @initDB()

  json: ->
    throw "news not ready" unless @articles?
    @articles

  initDB: => db =>
    db.connection
    .query
      "select news_feeds.url from news_feeds"
    .execute @_onFeedList

  _onFeedList: (e, feeds) =>
    if e?
      console.log "NEWS: Error loading news feeds from SQL"
      console.log e
    @_initFeed feed for feed in feeds

  _initFeed: (feed) ->
    reader = new FeedSub(feed.url,
      interval: @interval/(60*1000)
      emitOnStart: true
    )
    .on 'error', @_onFeedError
    .on 'item', @_onFeedItem
    .start()

  _onFeedError: (e) =>
    console.log "NEWS: Error getting news feed via REST"
    console.log e

  _onFeedItem: (item) =>
    console.log "news item!"
    console.log item
    @articles.unshift item
    @articles = @articles[0..@maxArticles-1] if @articles.length > @maxArticles
