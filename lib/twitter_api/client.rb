require 'faraday'
require 'json'
require 'logger'

module TwitterAPI
  class Error < StandardError; end

  class Client
    def initialize(token)
      @token = token
    end

    def connection
      @connection ||= Faraday::Connection.new do |b|
        b.adapter Faraday.default_adapter
      end
    end
  end
end
