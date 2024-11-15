# app/services/weather_service.rb
class WeatherService
  include HTTParty
  base_uri "https://api.weatherbit.io/v2.0/forecast/daily"

  def initialize(city, country)
    @city = city
    @country = country
    @api_key = ENV['WEATHER_API_KEY']
  end

  def fetch_forecast
    response = self.class.get("", query: {
      city: @city,
      country: @country,
      key: @api_key,
      days: 10
    })
    response.parsed_response
  end
end
  