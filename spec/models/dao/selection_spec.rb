require "rails_helper"

RSpec.describe Dao::Selection, :type => :model do
  context '#create' do
    it 'should create a selection' do
      tag1 = create(:tag)
      tag2 = create(:tag)
      tag3 = create(:tag)
      create_params = {
        name: "Selection Test",
        description: "Ceci est discription test.",
        tag_ids: [tag1.id, tag2.id, tag3.id],
        start_at: "17/05/2021",
        end_at: "18/06/2021",
        home_page: true,
        event: true,
        state: "active",
        image_url: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
        cover_url: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
        promoted: true
      }
      dto_variant = Dto::V1::Selection::Request.new(create_params)
      selection = Dao::Selection.create(dto_selection_request: dto_variant)

      expect(selection.name).to eq(create_params[:name])
      expect(selection.description).to eq(create_params[:description])
      expect(selection.tags.map {|tag| tag[:id]}).to eq(create_params[:tag_ids])
      expect(selection.begin_date).to_not be_nil
      expect(selection.end_date).to_not be_nil
      expect(selection.is_home).to eq(create_params[:home_page])
      expect(selection.is_event).to eq(create_params[:event])
      expect(selection.state).to eq(create_params[:state])
      expect(selection.image).to_not be_nil
      expect(selection.image.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(selection.cover_image).to_not be_nil
      expect(selection.cover_image.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(selection.featured).to eq(create_params[:promoted])
    end
  end

  context '#update' do
    it 'should update a selection' do
      tag1 = create(:tag)
      tag2 = create(:tag)
      tag3 = create(:tag)
      selection = create(:selection)
      update_params = {
        id: selection.id,
        name: "Selectiofaan Test",
        description: "Ceci est description test.",
        tag_ids: [tag1.id, tag2.id, tag3.id],
        start_at: "17/05/2021",
        end_at: "18/06/2021",
        home_page: true,
        event: true,
        state: "active",
        image_url: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
        cover_url: "https://www.japanfm.fr/wp-content/uploads/2021/03/Emma-Watson-Tous-les-films-a-venir-2021-Derniere-mise.jpg",
        promoted: true
      }
      dto_variant = Dto::V1::Selection::Request.new(update_params)
      selection = Dao::Selection.update(dto_selection_request: dto_variant)

      expect(selection.name).to eq(update_params[:name])
      expect(selection.description).to eq(update_params[:description])
      expect(selection.tags.map {|tag| tag[:id]}).to eq(update_params[:tag_ids])
      expect(selection.begin_date).to_not be_nil
      expect(selection.end_date).to_not be_nil
      expect(selection.is_home).to eq(update_params[:home_page])
      expect(selection.is_event).to eq(update_params[:event])
      expect(selection.state).to eq(update_params[:state])
      expect(selection.image).to_not be_nil
      expect(selection.image.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(selection.cover_image).to_not be_nil
      expect(selection.cover_image.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(selection.featured).to eq(update_params[:promoted])
    end
  end
end