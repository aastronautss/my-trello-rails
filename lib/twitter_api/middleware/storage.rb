module TwitterAPI
  module Middleware
    class Cache < Faraday::Middleware
      def initialize(app, storage={})
        super(app)
        @storage = storage
      end

      def call(env)
        key = env.url.to_s
        cached_response = Response.new(@storage.read(key))

        if cached_response.exist?
          if cached_response.fresh?
            response = @storage.read(key)
            response.env.response_headers["X-Faraday-Cache-Status"] = "true"
            return response
          elsif
            env.request_headers["If-None-Match"] = cached_response.etag
          end
        end

        response = @app.call(env)

        return response unless env.method == :get

        response.on_complete do |response_env|
          if Response.new(response).cachable?
            if response.status == 304
              cached_response = Response.new(@storage.read(key))
              cached_response.update_date(response)
              response.env.update(cached_response.env)
            end
            @storage.write(key, response)
          end
        end
        response
      end

      class Response
        def initialize(http_response)
          @http_response = http_response
        end

        def mandatory_refresh?
          @http_response.headers['Cache-Control'].include?('no-cache') || @http_response.headers['Cache-Control'].include?('must-validate')
        end

        def response_age
          date = @http_response.headers['Date']
          time = Time.httpdate(date) if date
          (Time.now - time).floor if time
        end

        def response_max_age
          cache_control = @http_response.headers['Cache-Control']
          return nil unless cache_control
          match = cache_control.match(/max\-age=(\d+)/)
          match[1].to_i if match
        end

        def fresh?
          age = response_age
          max_age = response_max_age

          if age && max_age && !mandatory_refresh?
            age < max_age
          end
        end

        def exist?
          !@http_response.nil?
        end

        def etag
          @http_response.headers['ETag']
        end

        def update_date(new_http_response)
          @http_response.headers['Date'] = new_http_response.headers['Date']
        end

        def env
          @http_response.env
        end

        def forbids_storage?
          cache_control_header.include?('no-store')
        end


        def cachable?
          cache_control_header && !forbids_storage?
        end

        def cache_control_header
          @cache_control_header ||= env.response_headers['Cache-Control']
        end
      end
    end
  end
end
