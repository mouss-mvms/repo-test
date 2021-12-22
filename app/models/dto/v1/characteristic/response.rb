module Dto
  module V1
    module Characteristic
      class Response
        attr_reader :name, :value

        def initialize(**args)
          @name = args[:name]
          @value = args[:value]
        end

        def to_h
          {
            name: @name,
            value: @value
          }
        end
      end
    end
  end
end