require "rails_helper"

RSpec.describe Dao::Variant, :type => :model do
  context '#create' do
    it 'should create a variant' do
      product = create(:available_product)
      create(:api_provider, name: 'wynd')
      create_params =
        {
          base_price: 20.5,
          weight: 20.5,
          quantity: 20,
          is_default: false,
          image_urls: [
            "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
          ],
          good_deal: {
            start_at: "20/01/2021",
            end_at: "16/02/2021",
            discount: "20"
          },
          external_variant_id: 69,
          characteristics: [
            {
              name: "color",
              value: "blue"
            },
            {
              name: "size",
              value: "S"
            }
          ],
          product_id: product.id
        }

      dto_variant = Dto::V1::Variant::Request.new(create_params)
      variant = Dao::Variant.create(dto_variant_request: dto_variant)

      expect(variant.base_price).to eq(dto_variant.base_price)
      expect(variant.weight).to eq(dto_variant.weight)
      expect(variant.quantity).to eq(dto_variant.quantity)
      expect(variant.is_default).to eq(dto_variant.is_default)
      expect(variant.image_urls).to eq(dto_variant.image_urls)
      expect(variant.good_deal).to eq(dto_variant.good_deal)
      expect(variant.external_variant_id).to eq(dto_variant.external_variant_id)
      expect(variant.characteristics).to eq(dto_variant.characteristics)
    end
  end

  # context '#update' do
  #   it 'should update a product' do
  #     shop = create(:shop)
  #     category = create(:category)
  #     reference = create(:reference, shop: shop)
  #     product = reference.product
  #     create(:api_provider, name: 'wynd')
  #     provider = {
  #       name: 'wynd',
  #       external_product_id: '33rt'
  #     }
  #     update_params = {
  #       name: "update de ses morts",
  #       shop_id: shop.id,
  #       description: "Chaise longue pour jardin extérieur.",
  #       category_id: category.id,
  #       brand: "Lafuma",
  #       status: "online",
  #       seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
  #       is_service: false,
  #       image_urls: [
  #         "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
  #       ],
  #       origin: "france",
  #       composition: "pouet pouet",
  #       allergens: "Eric Zemmour",
  #       variants: [
  #         {
  #           base_price: 20.5,
  #           weight: 20.5,
  #           quantity: 20,
  #           is_default: false,
  #           image_urls: [
  #             "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
  #           ],
  #           good_deal: {
  #             start_at: "20/01/2021",
  #             end_at: "16/02/2021",
  #             discount: "20"
  #           },
  #           characteristics: [
  #             {
  #               name: "color",
  #               value: "blue"
  #             },
  #             {
  #               name: "size",
  #               value: "S"
  #             }
  #           ]
  #         },
  #         {
  #           id: product.id,
  #           base_price: 20.5,
  #           weight: 20.5,
  #           quantity: 20,
  #           is_default: false,
  #           image_urls: [
  #             "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
  #           ],
  #           good_deal: {
  #             start_at: "20/01/2021",
  #             end_at: "16/02/2021",
  #             discount: "20"
  #           },
  #           characteristics: [
  #             {
  #               name: "color",
  #               value: "blue"
  #             },
  #             {
  #               name: "size",
  #               value: "S"
  #             }
  #           ]
  #         },
  #       ],
  #       provider: provider
  #     }
  #
  #     product = Dao::Product.update(product, update_params)
  #
  #     expect(product.name).to eq(update_params[:name])
  #     expect(product.shop_id).to eq(update_params[:shop_id])
  #     expect(product.id).not_to be_nil
  #     expect(product.name).to eq(update_params[:name])
  #     expect(product.category_id).to eq(update_params[:category_id])
  #     expect(product.brand.name).to eq(update_params[:brand])
  #     expect(product.is_a_service).to eq(update_params[:is_service])
  #     expect(product.pro_advice).to eq(update_params[:seller_advice])
  #     expect(product.description).to eq(update_params[:description])
  #     expect(product.origin).to eq(update_params[:origin])
  #     expect(product.allergens).to eq(update_params[:allergens])
  #     expect(product.composition).to eq(update_params[:composition])
  #     expect(product.images.first.file_url).to_not be_empty
  #     expect(product.samples.first.images.first.file_url).to_not be_empty
  #     expect(product.api_provider_products).to_not be_empty
  #     product_api_provider = product.api_provider_products.first
  #     expect(product_api_provider.api_provider.name).to eq(provider[:name])
  #     expect(product_api_provider.external_product_id).to eq(provider[:external_product_id])
  #   end
  # end
end