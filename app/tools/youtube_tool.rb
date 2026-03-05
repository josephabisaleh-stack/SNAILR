class YoutubeTool < RubyLLM::Tool
  description <<~DESC
    Search YouTube and return the 3 most relevant videos for a given query.
    Use  this tool to suggest educational or motivational resources related to
    the user's objective. Always call it after presenting the step plan.
  DESC

  param :query,
        type: :string,
        desc: "The search query based on the user's objective, e.g. 'how to train for a marathon beginner'"

  YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/search"

  def execute(query:)
    api_key = ENV["YOUTUBE_API_KEY"]
    return "YouTube suggestions unavailable: YOUTUBE_API_KEY is not configured." if api_key.blank?

    response = Faraday.get(YOUTUBE_API_URL, {
      key: api_key,
      q: query,
      part: "snippet",
      maxResults: 3,
      type: "video",
      relevanceLanguage: "en"
    })

    data = JSON.parse(response.body)

    if data["error"]
      return "YouTube search failed: #{data["error"]["message"]}"
    end

    items = data["items"]
    return "No videos found for: #{query}" if items.blank?

    result = "**📺 3 recommended videos for your objective:**\n\n"
    items.each_with_index do |item, index|
      video_id    = item["id"]["videoId"]
      title       = item["snippet"]["title"]
      channel     = item["snippet"]["channelTitle"]
      url         = "https://www.youtube.com/watch?v=#{video_id}"

      result += "#{index + 1}. **#{title}**\n"
      result += "   #{channel} — #{url}\n\n"
    end

    result.strip
  rescue StandardError => e
    "YouTube search failed: #{e.message}"
  end
end
