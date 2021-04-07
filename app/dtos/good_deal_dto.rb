class GoodDealDto
  attr_accessor :start_at, :end_at, :discount

  def initialize(**args)
    @start_at = args[:start_at]
    @end_at = args[:end_at]
    @discount = args[:discount]
  end


  def self.create(reference)
    return unless reference.good_deal
    GoodDealDto.new(start_at: reference&.good_deal&.start_at, end_at: reference&.good_deal&.end_at, discount: reference&.good_deal&.discount)
  end
end
