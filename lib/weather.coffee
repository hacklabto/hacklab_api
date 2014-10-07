WeatherJS = require('../node_modules/weather.js/weather.js')

class Weather
  location: "Toronto"
  interval: 60*1000 # Update the weather once every minute

  constructor: ->
    @data = current: {}, forecast: []
    @update()
    setInterval @update, @interval

  json: ->
    throw "weather data not ready" unless @currentRecieved and @forecastReceived
    @data

  update: =>
    WeatherJS.getCurrent  @location, @_onCurrentWeatherResponse
    WeatherJS.getForecast @location, @_onForecastResponse

  # See http://openweathermap.org/weather-conditions for conditions ids
  _onCurrentWeatherResponse: (current) => try
    @data.current.merge
      temperature: current.temperature()
      conditions:
        id: current.data.weather.id
        description: current.conditions()
    @currentRecieved = true
    console.log @data

  # Forecast index 0 is actually today's forecast. Index 1 is tomorrow's
  # forecast, etc.
  _onForecastResponse: (forecast) => try
    @data.forecast = []
    @data.forecast[i-1 ] = @_forecastJson(forecast, i) for i in [0..6]
    @data.current.merge @_forecastJson(forecast, 0)
    @forecastRecieved = true
    console.log @data

  _forecastJson: (forecast, i) ->
    d = new Date()
    d.setDate(d.getDate() + i)
    day = forecast.day(d)
    json =
      high: day.high()
      low: day.low()

module.exports = new Weather()