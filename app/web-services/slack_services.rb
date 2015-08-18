class SlackServices

  require 'net/https'
  require 'open-uri'
  URL_POST_MESSAGE = 'https://slack.com/api/chat.postMessage'
  URL_GET_USER_INFO= 'https://slack.com/api/users.info'

  def initialize (slack_forward_message, slack_params)
    @slack_forward_message = slack_forward_message
    @slack_params = slack_params

  end

  def get_user_info
    uri = URI URL_GET_USER_INFO
    resp = Net::HTTP.post_form(uri, setup_params_user_info)
    resp.body
  end

  def post_message
    @user_info = JSON.parse(get_user_info)
    uri = URI URL_POST_MESSAGE
    resp = Net::HTTP.post_form(uri, setup_params_post_message)
    p resp.body
  end

  private 
  def setup_params_post_message
    params = {'token'=> ENV['SLACK_API_KEY'],
              'channel'=>@slack_params[:channel_id],
              'text' => @slack_params[:command] + ' ' + @slack_params[:text] + "\n" + @slack_forward_message['text'],
              'as_user' => false,
              'attachments' => [{
                                "fallback" => @slack_params[:command] + ' ' + @slack_params[:text],
                                "pretext"=> @slack_params[:command] + ' ' + @slack_params[:text]
                                }],
              'username' => @user_info['user']['profile']['real_name'],
              'icon_url' => @user_info['user']['profile']['image_48'],
              'pretty' => 1}
    puts params
    return params
  end

  def setup_params_user_info
    params = {'token'=> ENV['SLACK_API_KEY'],
              'user'=>@slack_params[:user_id]
            }
    return  params
  end
end