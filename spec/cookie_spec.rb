# frozen_string_literal: true

RSpec.describe Cookie do
  it "has a version number" do
    expect(Cookie::VERSION).not_to be nil
  end
end
