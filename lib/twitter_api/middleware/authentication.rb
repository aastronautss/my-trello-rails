require 'simple_oauth'

module TwitterAPI
  module Middleware
    class Authentication < Faraday::Middleware
      AUTH_HEADER = 'Authorization'.freeze
      CONTENT_TYPE = 'Content-Type'.freeze
      TYPE_URLENCODED = 'application/x-www-form-urlencoded'.freeze

      def initialize(app, user_token, user_secret, consumer_token: ENV['twitter_api_key'], consumer_secret: ENV['twitter_api_secret'])
        super(app)
        @consumer_token = consumer_token
        @consumer_secret = consumer_secret
        @user_token = user_token
        @user_secret = user_secret
      end

      def call(env)
        env.request_headers[AUTH_HEADER] ||= oauth_header(env)
        env.request_headers[CONTENT_TYPE] ||= TYPE_URLENCODED
        require 'pry'; binding.pry
        @app.call(env).on_complete do |response_env|
          require 'pry'; binding.pry
          if response_env.status == 401
            raise AuthenticationFailure, response_env[:body]['message']
          end
        end
      end

      private

      def oauth_header(env)
        header = SimpleOAuth::Header.new  env[:method],
                                          env[:url].to_s,
                                          content_type_opts,
                                          oauth_hash
        header.to_s
      end

      def content_type_opts
        { }
      end

      def oauth_hash
        {
          consumer_key: @consumer_token,
          consumer_secret: @consumer_secret,
          token: @user_token,
          token_secret: @user_secret
        }
      end
    end
  end
end
