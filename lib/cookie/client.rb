# frozen_string_literal: true

require "json"
require "faraday"

module Cookie
  # Client for interacting with the Digital Cookie API
  #
  # @example Authenticate and create a new client
  #   client = Cookie::Client.authenticate(
  #     username: "user@example.com",
  #     credential: "password123"
  #   )
  #
  # @example Create a client with an existing token
  #   client = Cookie::Client.new(api_key: "existing_token")
  class Client
    BASE_URL = "https://apimobile.digitalcookie.girlscouts.org/mobileapp/api"

    # @return [Symbol] The Faraday adapter being used
    attr_reader :adapter

    # Authenticate with username and password to create a new client
    #
    # @param username [String] Email address for authentication
    # @param credential [String] Password for authentication
    # @return [Client] Authenticated client instance
    # @raise [UnauthorizedError] When credentials are invalid
    # @raise [ApiError] When the API request fails
    def self.authenticate(username:, credential:)
      client = new
      response = client.login.authenticate(username: username, credential: credential)
      client.setup_authorization(response.token)
      client
    end

    # Initialize a new API client
    #
    # @param api_key [String, nil] Bearer token for authentication
    # @param adapter [Symbol] The Faraday adapter to use
    # @return [Client] A new client instance
    def initialize(api_key: nil, adapter: Faraday.default_adapter)
      @api_key = api_key
      @adapter = adapter
    end

    # Set up authorization with a bearer token
    #
    # @param token [String] Bearer token for authentication
    # @return [void]
    def setup_authorization(token)
      @api_key = token

      # Reset the connection so it's rebuilt with the new token
      @connection = nil
    end

    # @return [Faraday::Connection] The configured HTTP client
    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter adapter
        faraday.headers["Authorization"] = "Bearer #{@api_key}" if @api_key
        faraday.headers["Content-Type"] = "application/json"
      end
    end

    # @return [Resources::Login] The login resource
    def login
      @login ||= Resources::Login.new(self)
    end
  end
end
