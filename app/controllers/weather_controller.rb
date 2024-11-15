# app/controllers/weather_controller.rb
class WeatherController < ApplicationController

  require 'carmen'

  def index
    @countries = Carmen::Country.all.map do |country|
      {
        name: country.name,
        code: country.alpha_3_code,
        flag: country_flag_emoji(country.alpha_2_code)
      }
    end
  end

  def fetch
    @countries = Carmen::Country.all.map do |country|
      {
        name: country.name,
        code: country.alpha_3_code,
        flag: country_flag_emoji(country.alpha_2_code)
      }
    end
    # Get city and country from params
    city = params[:city]
    country = params[:country]

    # Call the WeatherService to fetch the weather forecast
    service = WeatherService.new(city, country)
    forecast_data = service.fetch_forecast
    if forecast_data && forecast_data['data']
      @avg_temp = calculate_average_temperature(forecast_data['data'])
      @daily_forecasts = forecast_data['data'][0..6]
      @background_gradient = generate_background_gradient(@avg_temp)
    else
      flash[:error] = "The selected city does not belong to country. Please choose a valid city for the selected country."
    end
    render :index
  end

  private

  def country_flag_emoji(country_code)
    # Convert alpha-2 country code to flag emoji
    country_code.to_s.upcase.chars.map { |char| (char.ord + 127397).chr(Encoding::UTF_8) }.join
  end

  def calculate_average_temperature(forecast_data)
    temperatures = forecast_data.map { |day| day['temp'] }
    temperatures.sum / temperatures.size
  end

  def generate_background_gradient(avg_temp)
    color = case avg_temp
            when -60..-30 then "#2b0a3d" 
            when -30..-20 then "#00008b"
            when -20..-10 then "#0000ff"
            when -10..-1 then "#1e90ff"
            when -1..1 then "#00bfff"
            when 1..10 then "#00ffff"
            when 10..20 then "#ffff00"
            when 20..40 then "#ffbf00"
            else "#f00"
            end
    "linear-gradient(to bottom, #{color}, #{color})"
  end
end
