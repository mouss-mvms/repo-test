require "rails_helper"

RSpec.describe Dao::Selection, :type => :model do
  before :all do
    tag1 = create(:tag)
    tag2 = create(:tag)
    tag3 = create(:tag)
    @params = {
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
      promoted: true,
      long_description: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
      Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
      Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit."
    }
  end

  after :all do
    Selection.destroy_all
    Tag.destroy_all
    @params = nil
  end

  context '#create' do
    it 'should create a selection' do
      create_params = @params.clone
      dto_selection = Dto::V1::Selection::Request.new(create_params)
      selection = Dao::Selection.create(dto_selection_request: dto_selection)

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
      expect(selection.long_description).to eq(create_params[:long_description])
    end
  end

  context '#update' do
    it 'should update a selection' do
      selection = create(:selection)
      update_params = @params.clone
      update_params[:id] = selection.id
      dto_selection = Dto::V1::Selection::Request.new(update_params)
      selection = Dao::Selection.update(dto_selection_request: dto_selection)

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
      expect(selection.long_description).to eq(update_params[:long_description])
    end
  end
end