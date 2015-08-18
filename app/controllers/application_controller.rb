class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::MimeResponds
  def self.respond_to(*mimes)
    include ActionController::RespondWith::ClassMethods
    include ActionController::ImplicitRender
  end

  private 
    def convert_hash(params, video)
      return {
          "type" => "message",
          "text" =>'<https://www.youtube.com/watch?v=' + video + '>',
          "channel" => params[:channel_id],
          "user" => params[:user_id],
          "ts" => params[:timestamp]
          }

    end
end
