# frozen_string_literal: true

require_relative "cookie/client"
require_relative "cookie/models/base_response"
require_relative "cookie/models/login_response"
require_relative "cookie/models/order_response"
require_relative "cookie/resources/login"
require_relative "cookie/resources/orders"
require_relative "cookie/version"

module Cookie
  class Error < StandardError; end

  class UnauthorizedError < Error; end

  class AuthenticationError < Error; end

  class ApiError < Error; end
end
