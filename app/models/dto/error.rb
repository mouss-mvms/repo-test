module Dto
  class Error < StandardError
    attr_accessor :status, :message, :detail

    # @param [String] detail
    # @param [String] message
    # @param [Integer] status

    def initialize(detail:, message:, status:)
      @detail = detail
      @message = message
      @status = status
    end

    def to_h
      {
        detail: @detail,
        message: @message,
        status: @status
      }
    end
  end
end
