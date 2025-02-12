# frozen_string_literal: true

module Cookie
  module Resources
    # Handles order-related operations with the Digital Cookie API
    #
    # @example
    #   client = Cookie::Client.new(api_key: "your_key")
    #   orders = client.orders.get_hand_delivery("12345")
    #   puts orders.total_order_count
    #
    # @api public
    class Orders
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def get_hand_delivery(troop_id)
        response = @client.connection.get("getAllOrders/hand-delivery/#{troop_id}")
        order_response = Models::OrderResponse.new(response.body)

        if order_response.error?
          raise ApiError, order_response.error_message
        end

        order_response
      rescue Faraday::Error => e
        raise ApiError, "Request failed: #{e.message}"
      end
    end
  end
end
