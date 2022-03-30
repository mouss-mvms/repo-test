require 'rails_helper'

RSpec.describe Dto::V1::Selection::Response do
  describe "#create" do
    context "All ok" do
      it "should return a Dto::V1::Selection::Response" do
        image = create(:image)
        cover = create(:image)
        selection = create(:online_selection)
        selection.update(image_id: image.id, cover_image_id: cover.id)

        dto = Dto::V1::Selection::Response.create(selection)

        expect(dto).to be_instance_of(Dto::V1::Selection::Response)
        expect(dto.id).to eq(selection.id)
        expect(dto.slug).to eq(selection.slug)
        expect(dto.name).to eq(selection.name)
        expect(dto.description).to eq(selection.description)
        expect(dto.image).to be_instance_of(Dto::V1::Image::Response)
        expect(dto.tag_ids).to eq(selection.tag_ids)
        expect(dto.start_at).to eq(selection.begin_date)
        expect(dto.end_at).to eq(selection.end_date)
        expect(dto.home_page).to eq(selection.is_home)
        expect(dto.event).to eq(selection.is_event)
        expect(dto.state).to eq(selection.state)
        expect(dto.order).to eq(selection.order)
        expect(dto.products_count).to eq(selection.products.count)
        expect(dto.cover).to be_instance_of(Dto::V1::Image::Response)
        expect(dto.promoted).to eq(selection.featured)
      end
    end
  end
  describe "#to_h" do
    context "All ok" do
      it "should return a hash representation of Dto::V1::Selection::Response" do
        image = create(:image)
        selection = create(:online_selection)
        selection.update(image_id: image.id)

        dto = Dto::V1::Selection::Response.create(selection)
        dto_hash = dto.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:slug]).to eq(dto.slug)
        expect(dto_hash[:name]).to eq(dto.name)
        expect(dto_hash[:description]).to eq(dto.description)
        expect(dto_hash[:image]).to eq(dto.image.to_h)
        expect(dto_hash[:tagIds]).to eq(dto.tag_ids)
        expect(dto_hash[:startAt]).to eq(dto.start_at.strftime('%d/%m/%Y'))
        expect(dto_hash[:endAt]).to eq(dto.end_at.strftime('%d/%m/%Y'))
        expect(dto_hash[:homePage]).to eq(dto.home_page)
        expect(dto_hash[:event]).to eq(dto.event)
        expect(dto_hash[:state]).to eq(dto.state)
        expect(dto_hash[:order]).to eq(dto.order)
        expect(dto_hash[:productsCount]).to eq(dto.products_count)
        expect(dto_hash[:cover]).to eq(dto.cover.to_h)
        expect(dto_hash[:promoted]).to eq(dto.promoted)
      end
    end
  end
end
