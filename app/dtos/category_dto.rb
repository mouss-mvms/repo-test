class CategoryDto
  attr_accessor :id, :name

  def initialize(**args)
    @id = args[:id]
    @name = args[:name]
  end

  def self.create(product)
    return unless product.category
    CategoryDto.new(id: product.category.id, name: product.category.name)
  end
end
