class ProductDto
  attr_accessor :id, :name, :slug, :category, :brand, :status, :seller_advice, :description, :variants

  def initialize(**args)
    @id = args[:id]
    @name = args[:name]
    @slug = args[:slug]
    @category = args[:category]
    @brand = args[:brand]
    @status = args[:status]
    @seller_advice = args[:status]
    @description = args[:description]
    @variants = args[:variants]
  end

  def self.create(id)
      product = Product.find(id)
      dto_product = ProductDto.new( id: product.id, 
                                    name: product.name, 
                                    slug: product.slug, 
                                    brand: product&.brand&.name, 
                                    status: product.status, 
                                    seller_advice: product.pro_advice,
                                    category: CategoryDto.create(product),
                                    variants: product.references.map { |reference| VariantDto.create(reference) }
                                  )                                                                                                               
  end
end

