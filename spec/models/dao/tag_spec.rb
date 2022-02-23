require "rails_helper"

RSpec.describe Dao::Tag, :type => :model do
  describe '#create' do
    context 'when image id' do
      it 'creates a tag' do
        image = create(:image)
        create_params = {
          name: 'Chuck',
          status: 'inactive',
          featured: true,
          image_id: image.id
        }
        dto_tag_request = Dto::V1::Tag::Request.new(create_params)
        tag = Dao::Tag.create(dto_tag_request: dto_tag_request)

        expect(tag.name).to eq(create_params[:name])
        expect(tag.status).to eq(create_params[:status])
        expect(tag.featured).to eq(create_params[:featured])
        expect(tag.image_id).to eq(create_params[:image_id])
      end
    end

    context 'when image url' do
      it 'creates a tag' do
        create_params = {
          name: 'Chuck',
          status: 'inactive',
          featured: true,
          image_url: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg"
        }
        dto_tag_request = Dto::V1::Tag::Request.new(create_params)
        tag = Dao::Tag.create(dto_tag_request: dto_tag_request)

        expect(tag.name).to eq(create_params[:name])
        expect(tag.status).to eq(create_params[:status])
        expect(tag.featured).to eq(create_params[:featured])
        expect(tag.image_id).to_not be_nil
      end
    end
  end
end