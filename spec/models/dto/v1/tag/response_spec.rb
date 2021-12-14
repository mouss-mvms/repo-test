
require 'rails_helper'

RSpec.describe Dto::V1::Tag::Response do
  describe "#create" do
    context "All ok" do
      it "returns a Dto::V1::Tag::Response" do
        tag = create(:tag)
        tag.image_url = create(:image).file_url
        tag.save

        dto_tag = Dto::V1::Tag::Response.create(tag)

        expect(dto_tag).to be_instance_of(Dto::V1::Tag::Response)
        expect(dto_tag.id).to eq(tag.id)
        expect(dto_tag.name).to eq(tag.name)
        expect(dto_tag.status).to eq(tag.status)
        expect(dto_tag.featured).to eq(tag.featured)
        expect(dto_tag.image_url).to eq(tag.image_url)
      end
    end
  end

  describe "#to_h" do
    context "All ok" do
      it "returns a hash representation of Dto::V1::Tag::Response" do
        tag = create(:tag)
        tag.image_url = create(:image).file_url
        tag.save

        dto_tag = Dto::V1::Tag::Response.create(tag)
        dto_hash = dto_tag.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:id]).to eq(tag.id)
        expect(dto_hash[:name]).to eq(tag.name)
        expect(dto_hash[:status]).to eq(tag.status)
        expect(dto_hash[:featured]).to eq(tag.featured)
        expect(dto_hash[:imageUrl]).to eq(tag.image_url)
      end
    end

  end
end
