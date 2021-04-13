class VariantDto
  attr_accessor :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics

  def initialize(**args)
    @id = args[:id]
    @base_price = args[:base_price]
    @weight = args[:weight]
    @quantity = args[:quantity]
    @is_default = args[:default]
    @good_deal = args[:good_deal]
    @characteristics = []
  end

  def self.create(reference)
    variant = VariantDto.new(id: reference.id, weigth: reference.weight, quantity: reference.quantity, base_price: reference.base_price, is_default: reference.sample.default)
    variant.send(:create_characteristics, reference)
    variant.good_deal = GoodDealDto.create(reference)
    variant
  end

  private

  def create_characteristics(reference)
    self.characteristics << CharacteristicDto.new(name: reference.color.name, type: 'color') if reference.color
    self.characteristics << CharacteristicDto.new(name: reference.size.name, type: 'size') if reference.size
  end
end
