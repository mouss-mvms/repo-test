class ErrorDto
  attr_accessor :status, :message, :detail

  # @param [String] detail
  # @param [String] message
  # @param [Integer] status
  def initialize(detail, message, status)
    @detail = detail
    @message = message
    @status = status
  end
end
