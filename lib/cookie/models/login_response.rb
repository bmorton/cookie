# frozen_string_literal: true

module Cookie
  module Models
    # Response from the login endpoint containing authentication details
    #
    # @example
    #   response = login.authenticate(username: "user@example.com", credential: "password")
    #   puts response.token        # => "abc123"
    #   puts response.expired_in   # => 43050
    class LoginResponse < BaseResponse
      # @return [String] The authentication token for API requests
      attr_reader :token

      # @return [Integer] Time in seconds until the token expires
      attr_reader :expired_in

      # @param attributes [Hash] Raw response attributes from the API
      def initialize(attributes)
        super
        @token = attributes["token"]
        @expired_in = attributes["expiredIn"]
      end
    end
  end
end
