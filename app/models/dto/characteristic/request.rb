module Dto
  module Characteristic
    class Request
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