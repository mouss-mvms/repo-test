require 'rails_helper'

RSpec.describe Dao::Shop, type: :model do

  describe("#update") do
    context "All ok" do
      it 'should return a shop updated' do
        # Prepare
        shop = create(:shop)
        create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
        create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')

        dto_shop_request = Dto::V1::Shop::Request.new
        dto_shop_request.name = "Boutique MAJ"
        dto_shop_request.email = "email-maj@test.fr"
        dto_shop_request.siret = "75409821800029"
        dto_shop_request.mobile_number = "0612345678"
        dto_shop_request.facebook_link = "https://www.facebook.com/dummy/tests"
        dto_shop_request.instagram_link = "https://www.instagram.com/dummy/tests"
        dto_shop_request.website_link = "https://www.shop_url.com"
        dto_shop_request.description = "Description MAJ"
        dto_shop_request.baseline = "Baseline MAJ"

        dto_shop_request.address_request = Dto::V1::Address::Request.new
        dto_shop_request.address_request.addressable_id = shop.id
        dto_shop_request.address_request.addressable_type = "Shop"
        dto_shop_request.address_request.latitude = 44.84006
        dto_shop_request.address_request.longitude = -0.58397
        dto_shop_request.address_request.street_number = '52'
        dto_shop_request.address_request.route = 'Rue Georges Bonnac'
        dto_shop_request.address_request.locality = 'Bordeaux'
        dto_shop_request.address_request.country = 'France'
        dto_shop_request.address_request.postal_code = '33000'
        dto_shop_request.address_request.insee_code = '33063'

        # Execute
        Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

        # Assert
        expect(shop.name).to eq(dto_shop_request.name)
        expect(shop.email).to eq(dto_shop_request.email)
        expect(shop.siret).to eq(dto_shop_request.siret)
        expect(shop.mobile_phone_number).to eq(dto_shop_request.mobile_number)
        expect(shop.facebook_url).to eq(dto_shop_request.facebook_link)
        expect(shop.instagram_url).to eq(dto_shop_request.instagram_link)
        expect(shop.url).to eq(dto_shop_request.website_link)
        expect(shop.description).to eq(dto_shop_request.description)
        expect(shop.baseline).to eq(dto_shop_request.baseline)
        expect(shop.address).not_to be_nil
        expect(shop.address.street_number).to eq(dto_shop_request.address_request.street_number)
        expect(shop.address.route).to eq(dto_shop_request.address_request.route)
        expect(shop.address.locality).to eq(dto_shop_request.address_request.locality)
        expect(shop.address.country).to eq(dto_shop_request.address_request.country)
        expect(shop.address.postal_code).to eq(dto_shop_request.address_request.postal_code)
        expect(shop.address.latitude).to eq(dto_shop_request.address_request.latitude)
        expect(shop.address.longitude).to eq(dto_shop_request.address_request.longitude)
        expect(shop.address.addressable_id).to eq(dto_shop_request.address_request.addressable_id)
        expect(shop.address.addressable_id).to eq(shop.id)
        expect(shop.address.addressable_type).to eq("Shop")
      end

      context 'ImageUrl is set' do
        context 'For avatar' do
          it 'should return shop updated with avatar image set' do
            # Prepare
            shop = create(:shop, profil_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.avatar_url = "http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg"

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.profil_id).not_to be_nil
          end
        end

        context 'For cover' do
          it 'should return shop updated with cover image set' do
            # Prepare
            shop = create(:shop, featured_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.cover_url = "http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg"

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.featured_id).not_to be_nil
          end
        end

        context 'For thumbnail' do
          it 'should return shop updated with thumbnail image set' do
            # Prepare
            shop = create(:shop, thumbnail_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.thumbnail_url = "http://www.shutterstock.com/blog/wp-content/uploads/sites/5/2016/03/fall-trees-road-1.jpg"

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.thumbnail_id).not_to be_nil
          end
        end
      end

      context 'ImageId is set' do
        context 'For avatar' do
          it 'should return shop updated with avatar image set' do
            # Prepare
            shop = create(:shop, profil_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')
            image = create(:image)

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.avatar_id = image.id

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.profil_id).not_to be_nil
            expect(shop.profil_id).to eq(dto_shop_request.avatar_id)
          end
        end

        context 'For cover' do
          it 'should return shop updated with cover image set' do
            # Prepare
            shop = create(:shop, profil_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')
            image = create(:image)

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.cover_id = image.id

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.featured_id).not_to be_nil
            expect(shop.featured_id).to eq(dto_shop_request.cover_id)
          end
        end

        context 'For thumbnail' do
          it 'should return shop updated with avatar image set' do
            # Prepare
            shop = create(:shop, profil_id: nil)
            create(:city_referential, insee_code: '33063', name: 'Bordeaux', label: 'Bordeaux', department: '33')
            create(:city, name: 'Bordeaux', insee_code: '33063', zip_code: '33000', slug: 'bordeaux')
            image = create(:image)

            dto_shop_request = Dto::V1::Shop::Request.new
            dto_shop_request.thumbnail_id = image.id

            # Execute
            Dao::Shop.update(dto_shop_request: dto_shop_request , shop: shop)

            # Assert
            expect(shop.thumbnail_id).not_to be_nil
            expect(shop.thumbnail_id).to eq(dto_shop_request.thumbnail_id)
          end
        end
      end
    end
  end

end
