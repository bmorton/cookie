# frozen_string_literal: true

module Cookie
  module Models
    # Response containing order information and details
    #
    # @example
    #   orders = client.orders.get_hand_delivery("12345")
    #   puts orders.total_order_count # => 119
    #   puts orders.orders.first.order_number # => "132747574"
    class OrderResponse < BaseResponse
      attr_reader :can_view_details, :total_order_count, :orders

      def initialize(attributes)
        super
        @can_view_details = attributes["canViewDetails"]
        @total_order_count = attributes["totalOrderCount"]
        @orders = (attributes["orders"] || []).map { |order| Order.new(order) }
      end

      # Individual order details including purchase and payment information
      #
      # @example
      #   order = orders.orders.first
      #   puts order.order_number # => "132747574"
      #   puts order.number_purchased # => 2
      class Order
        attr_reader :date_actioned, :number_purchased, :order_number,
          :order_time_display, :payment_address, :sales_application

        def initialize(attributes)
          @date_actioned = attributes["dateActioned"]
          @number_purchased = attributes["numberPurchased"]
          @order_number = attributes["orderNumber"]
          @order_time_display = attributes["orderTimeDisplay"]
          @payment_address = PaymentAddress.new(attributes["paymentAddress"])
          @sales_application = attributes["salesApplication"]
        end

        # Payment and shipping address details for an order
        #
        # @example
        #   address = order.payment_address
        #   puts address.email # => "user@example.com"
        class PaymentAddress
          attr_reader :address_line1, :address_line2, :address_line3, :email,
            :first_name, :last_name, :phone_number, :town, :zip_code

          def initialize(attributes)
            @address_line1 = attributes["addressLine1"]
            @address_line2 = attributes["addressLine2"]
            @address_line3 = attributes["addressLine3"]
            @email = attributes["email"]
            @first_name = attributes["firstName"]
            @last_name = attributes["lastName"]
            @phone_number = attributes["phoneNumber"]
            @town = attributes["town"]
            @zip_code = attributes["zipCode"]
          end
        end
      end
    end
  end
end
