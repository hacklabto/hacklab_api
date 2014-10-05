weather = require('weather.js')

module.exports = class Weather
  location: "Toronto"
  interval: 60*1000 # Update the weather once every minute

  constructor: ->
    @data = current: {}, forecast: []
    @update()
    setInterval @update

  json: ->
    throw "weather data not ready" unless @currentRecieved and @forecastReceived
    @data

  update: =>
    Weather.getCurrent  @location, @_onCurrentWeatherResponse
    Weather.getForecast @location, @_onForecastResponse

  # See http://openweathermap.org/weather-conditions for conditions ids
  _onCurrentWeatherResponse: (current) =>
    @currentRecieved = true
    @data.current.merge
      temperature: current.temperature()
      conditions:
        id: current.data.weather.id
        description: current.conditions()
    console.log @data

  # Forecast index 0 is actually today's forecast. Index 1 is tomorrow's
  # forecast, etc.
  _onForecastResponse: (forecast) =>
    @forecastRecieved = true
    @data.forecast = []
    @data.forecast[i-1 ] = @_forecastJson(forecast, i) for i in (0..6)
    @data.current.merge @_forecastJson(forecast, 0)
    console.log @data

  _forecastJson: (forecast, i) ->
    d = new Date()
    d.setDate(d.getDate() + i)
    day = forecast.day(d)
    return
      high: day.high()
      low: day.low()
