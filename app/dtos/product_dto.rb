class ProductDto
  attr_accessor :id, :name, :slug, :category, :brand, :status, :seller_advice, :description, :variants

  def initialize
    @variants = []
  end
end

