module Dto
  module V1
    module Brand
      class Response
        attr_reader :id, :name

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
        end

        def self.create(brand:)
          new(
            id: brand.id,
            name: brand.name
          )
        end

        def to_h
          {
            id: id,
            name: name
          }
        end
      end
    end
  end
end