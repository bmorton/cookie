# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cookie::Resources::Login do
  subject(:login) { described_class.new(client) }

  let(:client) { Cookie::Client.new }
  let(:username) { "test@girlscouts.org" }
  let(:credential) { "password123" }

  describe "#authenticate" do
    subject(:authenticate) { login.authenticate(username: username, credential: credential) }

    context "when successful" do
      let(:response_body) do
        {
          type: "loginResponseTokenDTO",
          errorCode: "",
          errorMessage: "",
          expired: false,
          expiredIn: 43050,
          token: "test-token"
        }
      end

      before do
        stub_request(:post, "#{Cookie::Client::BASE_URL}/login")
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: response_body.to_json
          )
      end

      it "returns a login response" do
        expect(authenticate).to be_a(Cookie::Models::LoginResponse)
        expect(authenticate.token).to eq("test-token")
        expect(authenticate.expired_in).to eq(43050)
        expect(authenticate).not_to be_error
      end
    end

    context "when credentials are invalid" do
      let(:response_body) do
        {
          type: "loginResponseTokenDTO",
          errorCode: "500",
          errorMessage: "Oops! Your email or password is incorrect. Please try again.",
          expired: false
        }
      end

      before do
        stub_request(:post, "#{Cookie::Client::BASE_URL}/login")
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: response_body.to_json
          )
      end

      it "raises an unauthorized error" do
        expect { authenticate }.to raise_error(
          Cookie::UnauthorizedError,
          response_body[:errorMessage]
        )
      end
    end
  end
end
