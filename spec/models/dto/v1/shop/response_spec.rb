# frozen_string_literal: true

require "rails_helper"

RSpec.describe Dto::V1::Shop::Response do
  describe "#create" do
    context "All ok" do
      it "should return a Dto::V1::Shop::Response" do
        shop = create(:shop)
        product = create(:available_product, shop_id: shop.id)
        product.references.first.update(base_price: 50.99, shop_id: shop.id)
        product.references.last.update(shop_id: shop.id)
        create(:shop_gallery, shop_id: shop.id)
        dto_response = Dto::V1::Shop::Response.create(shop)

        expect(dto_response).to be_an_instance_of(Dto::V1::Shop::Response)
        expect(dto_response.id).to eq(shop.id)
        expect(dto_response.name).to eq(shop.name)
        expect(dto_response.slug).to eq(shop.slug)
        expect(dto_response.image_urls).to eq(shop.images.map { |image| image.file.url })
        expect(dto_response.description).to eq(shop.description)
        expect(dto_response.baseline).to eq(shop.baseline)
        expect(dto_response.facebook_link).to eq(shop.facebook_url)
        expect(dto_response.instagram_link).to eq(shop.instagram_url)
        expect(dto_response.website_link).to eq(shop.url)
        expect(dto_response.address).to be_an_instance_of(Dto::V1::Address::Response)
        expect(dto_response.siret).to eq(shop.siret)
        expect(dto_response.email).to eq(shop.email)
        expect(dto_response.lowest_product_price).to eq(shop.cheapest_ref.base_price)
        expect(dto_response.highest_product_price).to eq(shop.most_expensive_ref.base_price)
      end
    end
  end

  describe '#to_h' do
    context "All ok" do
      it 'should return a hash representation of a Dto::V1::Shop::Response' do
        shop = create(:shop)
        product = create(:available_product, shop_id: shop.id)
        product.references.first.update(base_price: 50.99, shop_id: shop.id)
        product.references.last.update(shop_id: shop.id)
        create(:shop_gallery, shop_id: shop.id)
        dto_response = Dto::V1::Shop::Response.create(shop)
        dto_hash = dto_response.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:id]).to eq(dto_response.id)
        expect(dto_hash[:name]).to eq(dto_response.name)
        expect(dto_hash[:slug]).to eq(dto_response.slug)
        expect(dto_hash[:imageUrls]).to eq(dto_response.image_urls)
        expect(dto_hash[:baseline]).to eq(dto_response.baseline)
        expect(dto_hash[:description]).to eq(dto_response.description)
        expect(dto_hash[:facebookLink]).to eq(dto_response.facebook_link)
        expect(dto_hash[:instagramLink]).to eq(dto_response.instagram_link)
        expect(dto_hash[:websiteLink]).to eq(dto_response.website_link)
        expect(dto_hash[:address]).to eq(dto_response.address.to_h)
        expect(dto_hash[:siret]).to eq(dto_response.siret)
        expect(dto_hash[:email]).to eq(dto_response.email)
        expect(dto_hash[:lowestProductPrice]).to eq(dto_response.lowest_product_price)
        expect(dto_hash[:highestProductPrice]).to eq(dto_response.highest_product_price)
      end
    end
  end
end
