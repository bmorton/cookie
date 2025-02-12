# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cookie::Resources::Orders do
  subject(:orders) { described_class.new(client) }

  let(:client) { Cookie::Client.new }
  let(:troop_id) { "12345" }

  describe "#get_hand_delivery" do
    subject(:get_hand_delivery) { orders.get_hand_delivery(troop_id) }

    context "when successful" do
      let(:response_body) { fixture("orders/get_all_hand_delivery_successful") }

      before do
        stub_request(:get, "#{Cookie::Client::BASE_URL}/getAllOrders/hand-delivery/#{troop_id}")
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: response_body.to_json
          )
      end

      it "returns an order response" do
        response = get_hand_delivery
        expect(response).to be_a(Cookie::Models::OrderResponse)
        expect(response.can_view_details).to be true
        expect(response.total_order_count).to eq 119
        expect(response.orders.count).to eq 4

        order = response.orders.first
        expect(order.number_purchased).to eq 2
        expect(order.order_number).to eq "132747574"
        expect(order.order_time_display).to eq "02/08/25"
        expect(order.sales_application).to eq "WebMobile"

        address = order.payment_address
        expect(address.email).to eq "ea8be985-b4e7-4633-a1fa-d9f2a68cdd07"
      end
    end
  end
end
