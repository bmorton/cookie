# frozen_string_literal: true

require "json"
require "faraday"

module Cookie
  # Client class handles all HTTP communication with the API
  #
  # @example Creating a new client
  #   client = YourGemName::Client.new(api_key: "your_key_here")
  #   client.connection # => Returns configured Faraday connection
  #
  # @attr_reader [String] api_key The API key used for authentication
  # @attr_reader [Symbol] adapter The Faraday adapter being used
  class Client
    attr_reader :api_key, :adapter

    # Initialize a new API client
    #
    # @param api_key [String] The API key for authentication
    # @param adapter [Symbol] The Faraday adapter to use
    # @return [Client] A new client instance
    def initialize(api_key:, adapter: Faraday.default_adapter)
      @api_key = api_key
      @adapter = adapter
    end

    # Returns a configured Faraday connection
    #
    # @return [Faraday::Connection] The configured connection
    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter adapter
        faraday.headers["Authorization"] = "Bearer #{api_key}"
        faraday.headers["Content-Type"] = "application/json"
      end
    end
  end
end
