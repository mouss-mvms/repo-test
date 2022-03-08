module Dao
  module Tag
    def self.create(dto_tag_request:)
      tag = ::Tag.create!(
        name: dto_tag_request.name,
        status: dto_tag_request.status,
        featured: dto_tag_request.featured
      )
      if dto_tag_request.image_id.present?
        tag.image_id = dto_tag_request.image_id
      else
        set_image(object: tag, image_url: dto_tag_request.image_url)
      end

      tag.save!
      tag
    end

    private

    def self.set_image(object:, image_url:)
      begin
        file = Shrine.remote_url(image_url)
        object.create_image(file: file)
      rescue StandardError => e
        Rails.logger.error(e)
        Rails.logger.error(e.message)
      end
    end
  end
end