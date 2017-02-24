require 'json'

module TwitterAPI
  module Middleware
    class JSONParsing < Faraday::Middleware
      def initialize(app, options = {})
        super app
      end

      def call(env)
        @app.call(env).on_complete do |env|
          if env[:response_headers]['Content-Type'] =~ %r{application/json}
            env[:raw_body] = env[:body]
            env[:body] = JSON.parse(env[:body]) if env[:body].size > 0
          end
        end
      end
    end
  end
end
