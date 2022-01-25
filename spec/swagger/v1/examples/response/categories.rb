module V1
  module Examples
    module Response
      class Categories
        def self.to_h
          {
            type: :array,
            items: V1::Examples::Response::Category.to_h
          }
        end
      end
    end
  end
end
