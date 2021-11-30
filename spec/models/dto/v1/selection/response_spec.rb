require 'rails_helper'

RSpec.describe Dto::V1::Selection::Response do
  describe "#create" do
    context "All ok" do
      it "should return a Dto::V1::Selection::Response" do
        image = create(:image)
        selection = create(:selection,
          name: "voiture",
          description: "Selection de voitures.",
          begin_date: "20/07/2021",
          end_date: "27/07/2021",
          is_home: false,
          is_event: false,
          state: "disabled",
          order: 1,
        )
        selection.update(image_id: image.id)

        dto = Dto::V1::Selection::Response.create(selection)

        expect(dto).to be_instance_of(Dto::V1::Selection::Response)
        expect(dto.id).to eq(selection.id)
        expect(dto.slug).to eq(selection.slug)
        expect(dto.name).to eq(selection.name)
        expect(dto.description).to eq(selection.description)
        expect(dto.image_url).to eq(selection&.image&.file_url)
        expect(dto.tag_ids).to eq(selection.tag_ids)
        expect(dto.start_at).to eq(selection.begin_date)
        expect(dto.end_at).to eq(selection.end_date)
        expect(dto.home_page).to eq(selection.is_home)
        expect(dto.event).to eq(selection.is_event)
        expect(dto.state).to eq(selection.state)
        expect(dto.order).to eq(selection.order)
      end
    end
  end
  describe "#to_h" do
    context "All ok" do
      it "should return a hash representation of Dto::V1::Selection::Response" do
        image = create(:image)
        selection = create(:selection,
          name: "voiture",
          description: "Selection de voitures.",
          begin_date: "20/07/2021",
          end_date: "27/07/2021",
          is_home: false,
          is_event: false,
          state: "disabled",
          order: 1
        )
        selection.update(image_id: image.id)

        dto = Dto::V1::Selection::Response.create(selection)
        dto_hash = dto.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:id]).to eq(selection.id)
        expect(dto_hash[:slug]).to eq(selection.slug)
        expect(dto_hash[:name]).to eq(selection.name)
        expect(dto_hash[:description]).to eq(selection.description)
        expect(dto_hash[:imageUrl]).to eq(selection&.image&.file_url)
        expect(dto_hash[:tagIds]).to eq(selection.tag_ids)
        expect(dto_hash[:startAt]).to eq(selection.begin_date.strftime('%d/%m/%Y'))
        expect(dto_hash[:endAt]).to eq(selection.end_date.strftime('%d/%m/%Y'))
        expect(dto_hash[:homePage]).to eq(selection.is_home)
        expect(dto_hash[:event]).to eq(selection.is_event)
        expect(dto_hash[:state]).to eq(selection.state)
        expect(dto_hash[:order]).to eq(selection.order)
      end
    end
  end
end
