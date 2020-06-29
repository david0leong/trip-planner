# frozen_string_literal: true

class ApiError < StandardError
  attr_reader :status

  def initialize(message = 'Api error', status: HTTP_BAD_REQUEST_CODE)
    @status = status

    super(message)
  end
end
