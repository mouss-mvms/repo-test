module Dao
  class Selection
    def self.create(dto_selection_request:)
      selection = ::Selection.create!(
        {
          name: dto_selection_request.name,
          description: dto_selection_request.description,
          begin_date: dto_selection_request.start_at,
          end_date: dto_selection_request.end_at,
          is_home: dto_selection_request.home_page,
          is_event: dto_selection_request.event,
          state: dto_selection_request.state
        }
      )

      set_image(object: selection, image_url: dto_selection_request.image_url)

      if dto_selection_request.image_url.present?
        tags = ::Tag.find(dto_selection_request.tag_ids)
        selection.tags = tags
      end

      selection.save!
      selection
    end

    def self.update(dto_selection_request:)
      selection = ::Selection.find(dto_selection_request.id)

      if dto_selection_request.tag_ids.any?
        tags = Tag.find(dto_selection_request.tag_ids)
        selection.tags = tags
      end

      if dto_selection_request.image_url.present?
        self.set_image(object: selection, image_url: dto_selection_request.image_url)
      end

      selection.name = dto_selection_request.name if dto_selection_request.name.present?
      selection.description = dto_selection_request.description if dto_selection_request.description.present?
      selection.begin_date = dto_selection_request.start_at if dto_selection_request.start_at.present?
      selection.end_date =dto_selection_request.end_at if dto_selection_request.end_at.present?
      selection.is_home = dto_selection_request.home_page if dto_selection_request.home_page
      selection.is_event = dto_selection_request.event if dto_selection_request.event
      selection.state = dto_selection_request.state if dto_selection_request.state.present?
      
      selection.save!
      selection
    end

    private

    def self.set_image(object:, image_url:)
      begin
        image = Shrine.remote_url(image_url)
        object.image = Image.create(file: image)
      rescue StandardError => e
        Rails.logger.error(e)
        Rails.logger.error(e.message)
      end
    end
  end
end

