module WeatherHelper
  def get_background_color(average_temp)
    hue = (average_temp + 10) * 12
    "hsl(#{hue}, 100%, 50%)"
  end
end
