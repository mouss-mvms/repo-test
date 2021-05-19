module Dto
  module Characteristic
    class Request
      attr_reader :name, :type

      def initialize(**args)
        @name = args[:name]
        @type = args[:type]
      end

    end
  end
end