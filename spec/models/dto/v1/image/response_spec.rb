require 'rails_helper'

RSpec.describe Dto::V1::Image::Response do
  describe "#create" do
    context "All ok" do
      it "should return a Dto::V1::Image::Response" do
        image = create(:image)
        dto_image = Dto::V1::Image::Response.create(image)

        expect(dto_image).to be_an_instance_of(Dto::V1::Image::Response)
        expect(dto_image.id).to eq(image.id)
        expect(dto_image.original_url).to eq(image.file_url)
        expect(dto_image.mini_url).to eq(image.file_url(:mini))
        expect(dto_image.thumb_url).to eq(image.file_url(:thumb))
        expect(dto_image.square_url).to eq(image.file_url(:square))
        expect(dto_image.wide_url).to eq(image.file_url(:wide))
      end
    end
  end

  describe "#to_h" do
    context "All ok" do
      it "shoulde return a hash representation of Dto::V1::Image::Response" do
        image = create(:image)
        dto_image = Dto::V1::Image::Response.create(image)
        dto_hash = dto_image.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:id]).to eq(image.id)
        expect(dto_hash[:originalUrl]).to eq(image.file_url)
        expect(dto_hash[:miniUrl]).to eq(image.file_url(:mini))
        expect(dto_hash[:thumbUrl]).to eq(image.file_url(:thumb))
        expect(dto_hash[:squareUrl]).to eq(image.file_url(:square))
        expect(dto_hash[:wideUrl]).to eq(image.file_url(:wide))
      end
    end
  end
end
