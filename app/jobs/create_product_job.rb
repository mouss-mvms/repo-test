class CreateProductJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options backtrace: 10

  def perform(*serialized_params)
    product_params = JSON.load(serialized_params.first).deep_symbolize_keys
    product = Dao::Product.create(product_params)
    store product_id: product.id
  end
end