# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cookie::Client do
  let(:username) { "test@girlscouts.org" }
  let(:credential) { "password123" }
  let(:token) { "test-token" }

  describe ".authenticate" do
    context "when successful" do
      let(:response_body) do
        {
          type: "loginResponseTokenDTO",
          errorCode: "",
          errorMessage: "",
          expired: false,
          expiredIn: 43050,
          token: token
        }
      end

      before do
        stub_request(:post, "#{described_class::BASE_URL}/login")
          .with(
            body: {
              uid: username,
              credential: credential,
              client: "gsa_mobile_iOS"
            }.to_json,
            headers: {"Content-Type" => "application/json"}
          )
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: response_body.to_json
          )
      end

      it "returns an authenticated client" do
        client = described_class.authenticate(username: username, credential: credential)
        expect(client).to be_a(described_class)
        expect(client.connection.headers["Authorization"]).to eq("Bearer #{token}")
      end
    end

    context "when authentication fails" do
      let(:response_body) do
        {
          type: "loginResponseTokenDTO",
          errorCode: "500",
          errorMessage: "Oops! Your email or password is incorrect. Please try again.",
          expired: false
        }
      end

      before do
        stub_request(:post, "#{described_class::BASE_URL}/login")
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: response_body.to_json
          )
      end

      it "raises an unauthorized error" do
        expect {
          described_class.authenticate(username: username, credential: credential)
        }.to raise_error(Cookie::UnauthorizedError, response_body[:errorMessage])
      end
    end
  end

  describe "#initialize" do
    it "creates a client without an api key" do
      client = described_class.new
      expect(client.connection.headers["Authorization"]).to be_nil
    end

    it "creates a client with an api key" do
      client = described_class.new(api_key: "test_key")
      expect(client.connection.headers["Authorization"]).to eq("Bearer test_key")
    end
  end

  describe "#setup_authorization" do
    it "sets the authorization header" do
      client = described_class.new
      client.setup_authorization("new_token")
      expect(client.connection.headers["Authorization"]).to eq("Bearer new_token")
    end
  end
end
