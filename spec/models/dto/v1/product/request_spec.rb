require 'rails_helper'

RSpec.describe Dto::V1::Product::Response do

  describe 'new' do
    context 'All ok' do
      it 'should return a Dto::Product::Request' do
        product_params = {
          name: "TEST Job create with sidekiq de ses morts",
          shop_id: 26,
          description: "Chaise longue pour jardin extérieur.",
          category_id: 2189,
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

        dto_product = Dto::V1::Product::Request.new(product_params)

        expect(dto_product.name).to eq(product_params[:name])
        expect(dto_product.shop_id).to eq(product_params[:shop_id])
        expect(dto_product.description).to eq(product_params[:description])
        expect(dto_product.category_id).to eq(product_params[:category_id])
        expect(dto_product.brand).to eq(product_params[:brand])
        expect(dto_product.status).to eq(product_params[:status])
        expect(dto_product.seller_advice).to eq(product_params[:seller_advice])
        expect(dto_product.is_service).to eq(product_params[:is_service])
        expect(dto_product.origin).to eq(product_params[:origin])
        expect(dto_product.allergens).to eq(product_params[:allergens])
        expect(dto_product.composition).to eq(product_params[:composition])
        expect(dto_product.variants.count).to eq(product_params[:variants].count)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Product::Request' do
        product_params = {
          name: "TEST Job create with sidekiq de ses morts",
          shop_id: 26,
          description: "Chaise longue pour jardin extérieur.",
          category_id: 2189,
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

        dto_product = Dto::V1::Product::Request.new(product_params)
        dto_hash = dto_product.to_h

        expect(dto_hash[:name]).to eq(dto_product.name)
        expect(dto_hash[:slug]).to eq(dto_product.slug)
        expect(dto_hash[:description]).to eq(dto_product.description)
        expect(dto_hash[:category_id]).to eq(dto_product.category_id)
        expect(dto_hash[:brand]).to eq(dto_product.brand)
        expect(dto_hash[:status]).to eq(dto_product.status)
        expect(dto_hash[:image_urls]).to eq(dto_product.image_urls)
        expect(dto_hash[:seller_advice]).to eq(dto_product.seller_advice)
        expect(dto_hash[:is_service]).to eq(dto_product.is_service)
        expect(dto_hash[:variants]).to eq(dto_product.variants&.map { |variant| variant.to_h })
        expect(dto_hash[:citizen_advice]).to eq(dto_product.citizen_advice)
      end
    end
  end
end