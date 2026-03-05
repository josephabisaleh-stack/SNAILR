class WeatherTool < RubyLLM::Tool
  description <<~DESC
    Get the current real-time weather for a given city.
    Use this tool whenever the user's objective involves a specific location,
    outdoor activities, or when weather conditions are relevant to their plan.
  DESC

  param :city,
        type: :string,
        desc: "The city name to get weather for, e.g. 'Paris', 'London', 'Tokyo'"

  WEATHER_CODES = {
    0 => "Clear sky",
    1 => "Mainly clear", 2 => "Partly cloudy", 3 => "Overcast",
    45 => "Fog", 48 => "Depositing rime fog",
    51 => "Light drizzle", 53 => "Moderate drizzle", 55 => "Dense drizzle",
    61 => "Slight rain", 63 => "Moderate rain", 65 => "Heavy rain",
    71 => "Slight snowfall", 73 => "Moderate snowfall", 75 => "Heavy snowfall",
    80 => "Slight rain showers", 81 => "Moderate rain showers", 82 => "Violent rain showers",
    95 => "Thunderstorm", 96 => "Thunderstorm with hail", 99 => "Thunderstorm with heavy hail"
  }.freeze

  def execute(city:)
    geo = geocode(city)
    return "Location '#{city}' not found." unless geo

    weather = fetch_weather(geo[:lat], geo[:lon])
    return "Could not retrieve weather for #{city}." unless weather

    current = weather["current_weather"]
    condition = WEATHER_CODES.fetch(current["weathercode"].to_i, "Unknown conditions")

    "Current weather in #{geo[:name]}, #{geo[:country]}: #{condition}. " \
    "Temperature: #{current["temperature"]}°C. " \
    "Wind: #{current["windspeed"]} km/h."
  rescue StandardError => e
    "Weather lookup failed: #{e.message}"
  end

  private

  def geocode(city)
    response = Faraday.get("https://geocoding-api.open-meteo.com/v1/search",
      { name: city, count: 1, language: "en", format: "json" })

    data = JSON.parse(response.body)
    result = data["results"]&.first
    return nil unless result

    { lat: result["latitude"], lon: result["longitude"],
      name: result["name"], country: result["country"] }
  end

  def fetch_weather(lat, lon)
    response = Faraday.get("https://api.open-meteo.com/v1/forecast",
      { latitude: lat, longitude: lon,
        current_weather: true,
        temperature_unit: "celsius",
        windspeed_unit: "kmh" })

    JSON.parse(response.body)
  end
end
