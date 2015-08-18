require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SlackYoutube
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    
    config.api_only = true
    config.active_record.raise_in_transactional_callbacks = true

    ### START OF CHANGES
    # wait for Rails to have loaded all its dependencies.
    config.after_initialize do
      messages = Queue.new # this is like redis or zero-mq, but it's dead simple.
                           # See also: http://ruby-doc.org/core-2.1.5/Queue.html

      # slack client thread, which will only forwards messages to the other
      # thread
      t = Thread.new do
        url = SlackRTM.get_url token: 'xoxp-9069528964-9069661783-9128947488-e87ec4' # get one on https://api.slack.com/web#basics
        client = SlackRTM::Client.new websocket_url: url
        client.on(:message) do |data|
          if data['type'] == 'message'
            messages << data
          end
        end
        client.main_loop # be careful, this never returns. That's why you need to thread.
      end
      t.abort_on_exception = true # will notify us if an exception happens

      t = Thread.new do
        loop do
          msg = messages.pop
          # do something with the slack message. Like storing in db, if you want to log
          puts msg.class # => Hash
          p msg     # => {type: 'message', user: 'U13131', channel: 'C121212', text: 'Hello world !'}
                    # see also: https://api.slack.com/events/message
        end
      end
      t.abort_on_exception = true # will notify us if an exception happens
    end
  end
end
