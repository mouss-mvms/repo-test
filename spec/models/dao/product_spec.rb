require "rails_helper"

RSpec.describe Dao::Product, :type => :model do
  context '#create' do

    context 'All ok' do
      context 'with image urls' do
        it 'should create a product' do
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
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
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.online?).to be_truthy
        end
      end

      context 'with image ids' do
        it 'should create a product' do
          image = create(:image)
          image.save!
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
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
                image_ids: [
                  image.id
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.online?).to be_truthy
        end
      end
    end

    context "The product doesn't meet the criteria to be online" do
      context "with image_urls" do
        it "should create a product but it's offline" do
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
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
                quantity: 0,
                is_default: false,
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.offline?).to be_truthy
        end

      end

      context "with image_ids" do
        it "should create a product but it's offline" do
          image = create(:image)
          image.save
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
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
                quantity: 0,
                is_default: false,
                image_ids: [
                  image.id
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.offline?).to be_truthy
        end
      end
    end

    context "The product is set as offline" do
      context "with image_urls" do
        it "should create a product and it's should be offline" do
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          create_params = {
            name: "TEST Job create with sidekiq de ses morts",
            shop_id: shop.id,
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "offline",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            origin: "france",
            composition: "pouet pouet",
            allergens: "Eric Zemmour",
            variants: [
              {
                base_price: 20.5,
                weight: 20.5,
                quantity: 45,
                is_default: false,
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.offline?).to be_truthy
        end
      end

      context "with image_ids" do
        it "should create a product and it's should be offline" do
          image = create(:image)
          image.save
          shop = create(:shop)
          category = create(:category)
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          create_params = {
            name: "TEST Job create with sidekiq de ses morts",
            shop_id: shop.id,
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "offline",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            origin: "france",
            composition: "pouet pouet",
            allergens: "Eric Zemmour",
            variants: [
              {
                base_price: 20.5,
                weight: 20.5,
                quantity: 45,
                is_default: false,
                image_ids: [
                  image.id
                ],
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
                ],
                external_variant_id: 'tre89'
              },
            ],
            provider: provider
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.api_provider_product).to_not be_nil
          expect(product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.offline?).to be_truthy
        end
      end
    end

    context "The product status is setted as submitted" do
      context "with image_urls" do
        it "should create a product and it's should be in submitted status" do
          shop = create(:shop)
          category = create(:category)
          create_params = {
            name: "TEST Job create with sidekiq de ses morts",
            shop_id: shop.id,
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "submitted",
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
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
              },
            ]
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.submitted?).to be_truthy
        end

      end

      context "with image_ids" do
        it "should create a product and it's should be in submitted status" do
          image = create(:image)
          image.save
          shop = create(:shop)
          category = create(:category)
          create_params = {
            name: "TEST Job create with sidekiq de ses morts",
            shop_id: shop.id,
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "submitted",
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
                image_ids: [
                  image.id
                ],
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
                ],
              },
            ]
          }

          dto_request = Dto::V1::Product::Request.new(create_params)
          product = Dao::Product.create(dto_request)

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
          expect(product.sample_images.first.file_url).to_not be_empty
          expect(product.sample_images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
          expect(product.colors.first.name).to eq(create_params[:variants].first[:characteristics].first[:value])
          expect(product.sizes.first.name).to eq(create_params[:variants].last[:characteristics].last[:value])
          expect(product.submitted?).to be_truthy
        end
      end
    end

    context "when the image url format is incorrect" do
      it 'should HTTP status 422' do
        shop = create(:shop)
        category = create(:category)
        create(:api_provider, name: 'wynd')
        provider = {
          name: 'wynd',
          external_product_id: '33rt'
        }
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
              image_urls: [
                "https://fr.wikipedia.org/wiki/Emma_Watson#/media/Fichier:Emma_Watson_2013.jpg"
              ],
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
              ],
              external_variant_id: 'tre89'
            },
          ],
          provider: provider
        }

        dto_request = Dto::V1::Product::Request.new(create_params)
        expect { Dao::Product.create(dto_request) }.to raise_error(ActiveRecord::RecordInvalid)
      end
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
          },
          external_variant_id: 'tre78'
        ]
      }

      expect(CreateProductJob).to receive(:perform_async).with(JSON.dump(create_params))
      Dao::Product.create_async(create_params)
    end
  end

  context '#update' do
    context "All ok" do
      it 'should update a product' do
        shop = create(:shop)
        category = create(:category)
        reference = create(:reference, shop: shop)
        product = reference.product
        create(:api_provider, name: 'wynd')
        provider = {
          name: 'wynd',
          external_product_id: '33rt'
        }
        update_params = {
          name: "update de ses morts",
          description: "Chaise longue pour jardin extérieur.",
          category_id: category.id,
          brand: "Lafuma",
          status: "online",
          seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
          is_service: false,
          image_urls: [
            "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
          ],
          origin: "france",
          composition: "oeuf",
          allergens: "Eric Zemmour",
          variants: [
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
              external_variant_id: 'tre89'
            },
            {
              id: reference.id,
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
              external_variant_id: 'tre91'
            },
          ],
          provider: provider
        }

        dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
        updated_product = Dao::Product.update(dto_product_request: dto_product_request)

        expect(updated_product.name).to eq(update_params[:name])
        expect(updated_product.category_id).to eq(update_params[:category_id])
        expect(updated_product.brand.name).to eq(update_params[:brand])
        expect(updated_product.is_a_service).to eq(update_params[:is_service])
        expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
        expect(updated_product.description).to eq(update_params[:description])
        expect(updated_product.origin).to eq(update_params[:origin])
        expect(updated_product.allergens).to eq(update_params[:allergens])
        expect(updated_product.composition).to eq(update_params[:composition])
        expect(updated_product.samples.first.images.first.file_url).to_not be_empty
        expect(updated_product.samples.first.images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be_truthy
        expect(updated_product.api_provider_product).to_not be_nil
        expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
        expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
      end
    end

    context "Product is offline" do
      context "Product is set online and requirements are ok" do
        it 'should update product and should be online' do
          shop = create(:shop)
          category = create(:category)
          reference = create(:reference, shop: shop)
          product = reference.product
          product.status = :offline
          product.save
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          update_params = {
            name: "update de ses morts",
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "online",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            image_urls: [
              "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
            ],
            origin: "france",
            composition: "oeuf",
            allergens: "Eric Zemmour",
            variants: [
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
                external_variant_id: 'tre89'
              },
              {
                id: reference.id,
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
                external_variant_id: 'tre91'
              },
            ],
            provider: provider
          }

          dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
          updated_product = Dao::Product.update(dto_product_request: dto_product_request)

          expect(updated_product.name).to eq(update_params[:name])
          expect(updated_product.category_id).to eq(update_params[:category_id])
          expect(updated_product.brand.name).to eq(update_params[:brand])
          expect(updated_product.is_a_service).to eq(update_params[:is_service])
          expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
          expect(updated_product.description).to eq(update_params[:description])
          expect(updated_product.origin).to eq(update_params[:origin])
          expect(updated_product.allergens).to eq(update_params[:allergens])
          expect(updated_product.composition).to eq(update_params[:composition])
          expect(updated_product.samples.first.images.first.file_url).to_not be_empty
          expect(updated_product.api_provider_product).to_not be_nil
          expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(updated_product.online?).to be_truthy
        end
      end

      context "Product is set online and requirements are not ok" do
        it 'should update product and should be offline' do
          shop = create(:shop)
          category = create(:category)
          reference = create(:reference, shop: shop)
          product = reference.product
          product.status = :offline
          product.save
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          update_params = {
            name: "update de ses morts",
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "online",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            image_urls: [
              "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
            ],
            origin: "france",
            composition: "oeuf",
            allergens: "Eric Zemmour",
            variants: [
              {
                base_price: 20.5,
                weight: 20.5,
                quantity: 0,
                is_default: false,
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
                external_variant_id: 'tre89'
              },
              {
                id: reference.id,
                base_price: 20.5,
                weight: 20.5,
                quantity: 0,
                is_default: false,
                image_urls: [
                  "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
                ],
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
                ],
                external_variant_id: 'tre91'
              },
            ],
            provider: provider
          }

          dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
          updated_product = Dao::Product.update(dto_product_request: dto_product_request)

          expect(updated_product.name).to eq(update_params[:name])
          expect(updated_product.category_id).to eq(update_params[:category_id])
          expect(updated_product.brand.name).to eq(update_params[:brand])
          expect(updated_product.is_a_service).to eq(update_params[:is_service])
          expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
          expect(updated_product.description).to eq(update_params[:description])
          expect(updated_product.origin).to eq(update_params[:origin])
          expect(updated_product.allergens).to eq(update_params[:allergens])
          expect(updated_product.composition).to eq(update_params[:composition])
          expect(updated_product.samples.first.images.first.file_url).to_not be_empty
          expect(updated_product.api_provider_product).to_not be_nil
          expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(updated_product.offline?).to be_truthy
        end
      end
    end

    context "Product is submitted" do
      context "Product is set as refused" do
        it 'should update product and should be refused' do
          shop = create(:shop)
          category = create(:category)
          reference = create(:reference, shop: shop)
          product = reference.product
          product.status = :submitted
          product.save
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          update_params = {
            name: "update de ses morts",
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "refused",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            image_urls: [
              "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
            ],
            origin: "france",
            composition: "oeuf",
            allergens: "Eric Zemmour",
            variants: [
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
                external_variant_id: 'tre89'
              },
              {
                id: reference.id,
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
                external_variant_id: 'tre91'
              },
            ],
            provider: provider
          }

          dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
          updated_product = Dao::Product.update(dto_product_request: dto_product_request)

          expect(updated_product.name).to eq(update_params[:name])
          expect(updated_product.category_id).to eq(update_params[:category_id])
          expect(updated_product.brand.name).to eq(update_params[:brand])
          expect(updated_product.is_a_service).to eq(update_params[:is_service])
          expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
          expect(updated_product.description).to eq(update_params[:description])
          expect(updated_product.origin).to eq(update_params[:origin])
          expect(updated_product.allergens).to eq(update_params[:allergens])
          expect(updated_product.composition).to eq(update_params[:composition])
          expect(updated_product.samples.first.images.first.file_url).to_not be_empty
          expect(updated_product.api_provider_product).to_not be_nil
          expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(updated_product.refused?).to be_truthy
        end
      end

      context "Product is accepted" do
        it 'should return updated product with offline or online status' do
          shop = create(:shop)
          category = create(:category)
          reference = create(:reference, shop: shop)
          product = reference.product
          product.status = :submitted
          product.save
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          update_params = {
            name: "update de ses morts",
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "online",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            image_urls: [
              "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
            ],
            origin: "france",
            composition: "oeuf",
            allergens: "Eric Zemmour",
            variants: [
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
                external_variant_id: 'tre89'
              },
              {
                id: reference.id,
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
                external_variant_id: 'tre91'
              },
            ],
            provider: provider
          }

          dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
          updated_product = Dao::Product.update(dto_product_request: dto_product_request)

          expect(updated_product.name).to eq(update_params[:name])
          expect(updated_product.category_id).to eq(update_params[:category_id])
          expect(updated_product.brand.name).to eq(update_params[:brand])
          expect(updated_product.is_a_service).to eq(update_params[:is_service])
          expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
          expect(updated_product.description).to eq(update_params[:description])
          expect(updated_product.origin).to eq(update_params[:origin])
          expect(updated_product.allergens).to eq(update_params[:allergens])
          expect(updated_product.composition).to eq(update_params[:composition])
          expect(updated_product.samples.first.images.first.file_url).to_not be_empty
          expect(updated_product.api_provider_product).to_not be_nil
          expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(updated_product.offline? || updated_product.online?).to be_truthy
        end
      end

    end

    context "Product is not submitted" do
      context "Product is set as refused" do
        it 'should update product and the status should not changed' do
          shop = create(:shop)
          category = create(:category)
          reference = create(:reference, shop: shop)
          product = reference.product
          product.status = :offline
          product.save
          create(:api_provider, name: 'wynd')
          provider = {
            name: 'wynd',
            external_product_id: '33rt'
          }
          update_params = {
            name: "update de ses morts",
            description: "Chaise longue pour jardin extérieur.",
            category_id: category.id,
            brand: "Lafuma",
            status: "refused",
            seller_advice: "Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.",
            is_service: false,
            image_urls: [
              "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
            ],
            origin: "france",
            composition: "oeuf",
            allergens: "Eric Zemmour",
            variants: [
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
                external_variant_id: 'tre89'
              },
              {
                id: reference.id,
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
                external_variant_id: 'tre91'
              },
            ],
            provider: provider
          }

          dto_product_request = Dto::V1::Product::Request.new(update_params.merge(id: product.id))
          updated_product = Dao::Product.update(dto_product_request: dto_product_request)

          expect(updated_product.name).to eq(update_params[:name])
          expect(updated_product.category_id).to eq(update_params[:category_id])
          expect(updated_product.brand.name).to eq(update_params[:brand])
          expect(updated_product.is_a_service).to eq(update_params[:is_service])
          expect(updated_product.pro_advice).to eq(update_params[:seller_advice])
          expect(updated_product.description).to eq(update_params[:description])
          expect(updated_product.origin).to eq(update_params[:origin])
          expect(updated_product.allergens).to eq(update_params[:allergens])
          expect(updated_product.composition).to eq(update_params[:composition])
          expect(updated_product.samples.first.images.first.file_url).to_not be_empty
          expect(updated_product.api_provider_product).to_not be_nil
          expect(updated_product.api_provider_product.api_provider.name).to eq(provider[:name])
          expect(updated_product.api_provider_product.external_product_id).to eq(provider[:external_product_id])
          expect(updated_product.offline?).to be_truthy
        end
      end
    end
  end
end