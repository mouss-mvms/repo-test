class CreateProductJob
  include Sidekiq::Worker
  sidekiq_options backtrace: 10

  def perform(*serialized_params)
    product_params = JSON.load(serialized_params.first).deep_symbolize_keys
    Dao::Product.create(product_params)
  end
end