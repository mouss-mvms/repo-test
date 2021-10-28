module Dto
  module V1
    module Provider
      module Variant
        class Request
          attr_accessor :name, :external_variant_id

          def initialize(**args)
            @name = args[:name]
            @external_variant_id = args[:external_variant_id]
          end
        end
      end
    end
  end
end
