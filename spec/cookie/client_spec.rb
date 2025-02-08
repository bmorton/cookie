# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cookie::Client do
  let(:api_key) { "test_key" }
  let(:client) { described_class.new(api_key: api_key) }

  describe "#initialize" do
    it "creates a client with an API key" do
      expect(client.api_key).to eq(api_key)
    end

    it "sets a default adapter" do
      expect(client.adapter).to eq(Faraday.default_adapter)
    end
  end

  describe "#connection" do
    let(:connection) { client.connection }

    it "creates a Faraday connection" do
      expect(connection).to be_a(Faraday::Connection)
    end

    it "sets the Authorization header" do
      expect(connection.headers["Authorization"]).to eq("Bearer #{api_key}")
    end

    it "sets the Content-Type header" do
      expect(connection.headers["Content-Type"]).to eq("application/json")
    end

    it "memoizes the connection" do
      expect(client.connection).to eq(client.connection)
    end
  end
end
