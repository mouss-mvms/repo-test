require "rails_helper"

RSpec.describe Dao::Product, :type => :model do
  context '#create' do
    it 'should create a product' do
      shop = create(:shop)
      category = create(:category)
      create_params = {
        name: "TEST Job create with sidekiq de ses morts",
        shop_id: shop.id,
        description: "Chaise longue pour jardin extérieur.",
        category_id: category.id,
        brand: "Lafuma",
        status: "online",
        seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
        is_service: false,
        origin: "france",
        composition: "pouet pouet",
        allergens: "Eric Zemmour",
        variants: [
          {
            base_price: 20.5,
            weight: 20.5,
            quantity: 20,
            is_default: false,
            good_deal: {
              start_at: "20/01/2021",
              end_at: "16/02/2021",
              discount: "20"
            },
            characteristics: [
              {
                name: "color",
                value: "blue"
              },
              {
                  name: "size",
                  value: "S"
              }
            ]
          }
        ]
      }

      product = Dao::Product.create(create_params)

      expect(product.name).to eq(create_params[:name])
      expect(product.shop_id).to eq(create_params[:shop_id])
      expect(product.id).not_to be_nil
      expect(product.name).to eq(create_params[:name])
      expect(product.category_id).to eq(create_params[:category_id])
      expect(product.brand.name).to eq(create_params[:brand])
      expect(product.is_a_service).to eq(create_params[:is_service])
      expect(product.pro_advice).to eq(create_params[:seller_advice])
      expect(product.description).to eq(create_params[:description])
      expect(product.origin).to eq(create_params[:origin])
      expect(product.allergens).to eq(create_params[:allergens])
      expect(product.composition).to eq(create_params[:composition])
    end
  end

  context '#create_async' do
    it 'should call CreateProductJob' do
      shop = create(:shop)
      category = create(:category)
      create_params = {
        name: "TEST Job create with sidekiq de ses morts",
        shop_id: shop.id,
        description: "Chaise longue pour jardin extérieur.",
        category_id: category.id,
        brand: "Lafuma",
        status: "online",
        seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
        is_service: false,
        origin: "france",
        composition: "pouet pouet",
        allergens: "Eric Zemmour",
        variants: [
          {
            base_price: 20.5,
            weight: 20.5,
            quantity: 20,
            is_default: false,
            good_deal: {
              start_at: "20/01/2021",
              end_at: "16/02/2021",
              discount: "20"
            },
            characteristics: [
              {
                name: "color",
                value: "blue"
              },
              {
                  name: "size",
                  value: "S"
              }
            ]
          }
        ]
      }

      expect(CreateProductJob).to receive(:perform_async).with(JSON.dump(create_params))
      Dao::Product.create_async(create_params)
    end
  end
end