class YoutubeService
    # Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
  # tab of
  # Google Developers Console <https://console.developers.google.com/>
  # Please ensure that you have enabled the YouTube Data API for your project.

  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def initialize
    @client = Google::APIClient.new(
      :key => ENV['GOOGLE_DEVELOPER_KEY'],
      :authorization => nil,
      :application_name => $PROGRAM_NAME,
      :application_version => '1.0.0'
    )
    @youtube = @client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
  end

  def send_request(user_search, max_result)
    begin
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = @client.execute!(
        :api_method => @youtube.search.list,
        :parameters => {
          :part => 'snippet',
          :q => user_search,
          :maxResults => max_result
        }
      )

      videos = []
      channels = []
      playlists = []

      # Add each result to the appropriate list, and then display the lists of
      # matching videos with id
      search_response.data.items.each do |search_result|
        case search_result.id.kind
          when 'youtube#video'
            videos << "(#{search_result.id.videoId})"
        end
      end
      puts videos
      if videos.empty?
        return false, nil
      end
      return true, get_random_video(videos, max_result)

    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
      puts e.result
      return false, nil
    end
  end

  private 

  def get_random_video(videos, maxResult)
    # sometime youtube get an empty id.
    video = videos[rand(0..maxResult - 1)]
    while video.nil? do
      video = videos[rand(0..maxResult - 1)]
    end
    return strip_parentheses(video)
  end

  def strip_parentheses(video)
      return video.delete('()')
  end
end