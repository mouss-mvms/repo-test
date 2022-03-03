module Dto
  module V1
    module Tag
      class Request
        attr_accessor :name, :status, :featured, :image_id, :image_url

        def initialize(**args)
          @name = args[:name]
          @status = args[:status]
          @featured = args[:featured]
          @image_id = args[:image_id]
          @image_url = args[:image_url]
        end
      end
    end
  end
end
