Rails.application.routes.draw do
  # Root route for the weather app
  root "weather#index"
  
  # Custom route for the 'fetch' action (POST request)
  post "weather/fetch", to: "weather#fetch", as: "weather_fetch"
end