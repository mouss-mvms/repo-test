class ProductCreateAndUpdateJob < ApplicationJob
  queue_as :default

  def perform(serialized_dto_product_request:, product: nil, citizen_id: nil)
    dto_product_request = Dto::Product::Request.new(JSON.parse(serialized_dto_product_request).deep_symbolize_keys)
    Dto::Product.build(dto_product_request: dto_product_request, product: product, citizen_id: citizen_id)
  end
end