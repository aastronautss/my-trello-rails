require 'logger'

module TwitterAPI
  module Middleware
    class Logging < Faraday::Middleware
      def initialize(app)
        super(app)
        @logger = logger
      end

      def call(env)
        start_time = Time.now
        url, method = env.url.to_s, env.method

        @app.call(env).on_complete do |response_env|
          duration = Time.now - start_time
          status = response_env.status
          cached = response_env.response_headers["X-Faraday-Cache-Status"] ? "hit" : "miss"
          @logger.debug '-> %s %s %d (%.3f s) %s' % [url, method.to_s.upcase, status, duration, cached]
        end
      end

      def logger
        level = ENV["LOG_LEVEL"]
        logger = Logger.new(STDOUT)
        logger.formatter = proc { |severity, datetime, program, message| message + "\n" }
        logger.level = Logger.const_get(level) if level
        logger
      end
    end
  end
end
