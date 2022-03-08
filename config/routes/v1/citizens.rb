get "/citizens/:id/products", to: "citizens/products#index"
scope :auth do
  namespace :citizens, path: "citizens/self" do
    instance_eval(File.read(Rails.root.join("config/routes/v1/citizens/products.rb")))
  end
end