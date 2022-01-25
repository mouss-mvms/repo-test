module Dto
  module V1
    module Image
      class Response
        attr_accessor :id, :original_url, :mini_url, :thumb_url, :square_url, :wide_url

        def initialize(**args)
          @id = args[:id]
          @original_url = args[:original_url]
          @mini_url = args[:mini_url]
          @thumb_url = args[:thumb_url]
          @square_url = args[:square_url]
          @wide_url = args[:wide_url]
        end

        def self.create(image)
          return nil if image.nil?
          new(
            id: image.id,
            original_url: image.file_url,
            mini_url: image.file_url(:mini),
            thumb_url: image.file_url(:thumb),
            square_url: image.file_url(:square),
            wide_url: image.file_url(:wide)
          )
        end

        def to_h
          {
            id: @id,
            originalUrl: @original_url,
            miniUrl: @mini_url,
            thumbUrl: @thumb_url,
            squareUrl: @square_url,
            wideUrl: @wide_url
          }
        end
      end
    end
  end
end