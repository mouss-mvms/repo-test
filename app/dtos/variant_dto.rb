class VariantDto
  attr_accessor :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics

  def initialize
    @characteristics = []
  end
end
