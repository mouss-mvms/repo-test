module Dto
  module V1
    module Image
      class Request
        attr_reader :content_type, :headers, :original_filename, :tempfile

        def initialize(**args)
          @content_type = args[:content_type]
          @headers = args[:headers]
          @original_filename = args[:original_filename]
          @tempfile = args[:tempfile]
        end

        def self.create(image:)
          Dto::V1::Image::Request.new(
            content_type: image.content_type,
            headers: image.headers,
            original_filename: image.original_filename,
            tempfile: image.tempfile
          )
        end
      end
    end
  end
end