# frozen_string_literal: true

module Cookie
  module Models
    # Base class for API responses that provides error checking capabilities
    #
    # @abstract Subclass and add attributes specific to the endpoint
    class BaseResponse
      # @return [String] The type of response from the API
      attr_reader :type

      # @return [String, nil] Error code if present
      attr_reader :error_code

      # @return [String, nil] Error message if present
      attr_reader :error_message

      # @return [Boolean] Whether the session is expired
      attr_reader :expired

      # @param attributes [Hash] Raw response attributes from the API
      def initialize(attributes)
        @type = attributes["type"]
        @error_code = attributes["errorCode"]
        @error_message = attributes["errorMessage"]
        @expired = attributes["expired"] || false
      end

      # @return [Boolean] Whether the response contains an error
      def error?
        !!(error_code && !error_code.empty?)
      end

      # @return [Boolean] Whether the error is an authentication error
      def authentication_error?
        error? && error_code == "500"
      end
    end
  end
end
