class GoodDealDto
  attr_accessor :start_at, :end_at, :discount

  def initialize(**args)
    @start_at = args[:start_at]
    @end_at = args[:end_at]
    @discount = args[:discount]
  end


  def self.create(reference)
    return unless reference.good_deal
    GoodDealDto.new(start_at: reference&.good_deal&.starts_at.to_time.to_i, end_at: reference&.good_deal&.ends_at.to_time.to_i, discount: reference&.good_deal&.discount)
  end
end
