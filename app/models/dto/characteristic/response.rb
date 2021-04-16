module Dto
  module Characteristic
    class Response
      attr_reader :name, :type

      def initialize(**args)
        @name = args[:name]
        @type = args[:type]
      end
    
      def self.create(**args)
        Dto::Characteristic::Response.new(
          name: args[:name],
          type: args[:type]
        )
      end

      def to_h
        {
          name: @name,
          type: @type
        }
      end
    end
  end
end