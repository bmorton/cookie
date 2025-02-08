# frozen_string_literal: true

require "json"

module Cookie
  module Resources
    # Handles authentication with the Digital Cookie API
    #
    # @example
    #   client = Cookie::Client.new(api_key: "your_key")
    #   response = client.login.authenticate(
    #     username: "user@example.com",
    #     credential: "password123"
    #   )
    #   puts response.token
    #
    # @api public
    class Login
      # @return [Cookie::Client] The configured API client
      attr_reader :client

      # Initialize a new login resource
      #
      # @param client [Cookie::Client] The configured API client
      # @return [Login] A new instance of Login
      def initialize(client)
        @client = client
      end

      # Authenticate with the Digital Cookie API
      #
      # @param username [String] The user's email address
      # @param credential [String] The user's password
      # @return [Models::LoginResponse] The response containing authentication tokens
      #
      # @example
      #   login.authenticate(
      #     username: "user@example.com",
      #     credential: "password123"
      #   )
      def authenticate(username:, credential:)
        response = @client.connection.post(
          "login",
          build_request_body(username, credential)
        )

        login_response = Models::LoginResponse.new(response.body)

        if login_response.authentication_error?
          raise UnauthorizedError, login_response.error_message
        elsif login_response.error?
          raise ApiError, login_response.error_message
        end

        login_response
      rescue Faraday::Error => e
        raise ApiError, "Request failed: #{e.message}"
      end

      private

      def build_request_body(username, credential)
        JSON.generate({
          uid: username,
          credential: credential,
          client: "gsa_mobile_iOS"
        })
      end
    end
  end
end
