require 'faraday'
require 'json'
require 'logger'
require 'faraday_middleware/request/oauth'

require_relative 'middleware/status_check'
require_relative 'middleware/authentication'
require_relative 'middleware/json_parsing'
require_relative 'middleware/logging'
# require_relative 'middleware/cache'

require_relative 'storage/redis'

module TwitterAPI
  class Error < StandardError; end
  class RequestFailure < Error; end
  class AuthenticationFailure < Error; end
  class TweetCreationFailure < Error; end

  Tweet = Struct.new :text, :username

  class Client
    def initialize(user_token, user_secret)
      @user_token = user_token
      @user_secret = user_secret
    end

    def connection
      @connection ||= Faraday::Connection.new do |b|
        b.use Middleware::StatusCheck
        b.use FaradayMiddleware::OAuth, oauth_options
        b.use Middleware::JSONParsing
        b.use Middleware::Logging
        # b.use Middleware::Cache, Storage::Redis.new

        b.adapter Faraday.default_adapter
      end
    end

    def create_tweet(params)
      url = "https://api.twitter.com/1.1/statuses/update.json"
      payload = JSON.dump({
        status: params[:status]
      })

      response = connection.post url, payload

      require 'pry'; binding.pry

      if response.status == 201
        body = response.body
        Tweet.new body['text'], body['user']['screen_name']
      else
        raise TweetCreationFailure, response.body['message']
      end
    end

    private

    def oauth_options
      {
        consumer_key: ENV['twitter_api_key'],
        consumer_secret: ENV['twitter_api_secret'],
        token: @user_token,
        token_secret: @user_secret
      }
    end
  end
end

# s = Service.first
# c = TwitterAPI::Client.new s.token, s.secret
# c.create_tweet status: 'testing from my app!'
