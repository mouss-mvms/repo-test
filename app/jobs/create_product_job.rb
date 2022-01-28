class CreateProductJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options backtrace: 10

  def perform(*serialized_params)
    product_params = JSON.load(serialized_params.first).deep_symbolize_keys
    dto_product_request = Dto::V1::Product::Request.new(product_params)
    product = Dao::Product.create(dto_product_request)
    store product_id: product.id
  end
end