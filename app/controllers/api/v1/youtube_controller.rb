module Api
  module V1
    class YoutubeController < ApplicationController
      before_action :check_token, only: [:get_youtube_video_id]
      def get_youtube_video_id
        youtube_service = YoutubeService.new
        status, video = youtube_service.send_request(params[:text], 20)
        if status
          slack_forward_message = convert_hash(params, video)
          slack_service = SlackServices.new(slack_forward_message, params)
          slack_service.post_message
          render :nothing => true
          return
        end
        render text: ('Videos not found with the string: ' + params[:text])
      end

      private
      def check_token
        if params[:token] != ENV['SLACK_TOKEN']
          raise ('Slack Token is not authenticated!!!!')
        end
      end
    end
  end
end