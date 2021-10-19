module Dto
  module V1
    module BrandSummary
      class Response
        attr_reader :_index, :_type, :_id, :_score, :id, :name, :products_count

        def initialize(**args)
          @_index = args[:_index]
          @_type = args[:_type]
          @_id = args[:_id]
          @_score = args[:_score]
          @id = args[:id]
          @name = args[:name]
          @products_count = args[:products_count]
        end

        def self.create(searchkick_brand_response)
          Dto::V1::BrandSummary::Response.new(searchkick_brand_response)
        end

        def to_h
          {
            _index: _index,
            _type: _type,
            _id: _id,
            _score: _score,
            id: id,
            name: name,
            productsCount: products_count,
          }
        end
      end
    end
  end
end