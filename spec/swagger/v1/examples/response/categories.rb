module V1
  module Examples
    module Response
      class Categories
        def self.to_h
          {
            type: 'object',
            properties: {
              categories: {
                type: :array,
                items: V1::Examples::Response::Category.to_h
              },
              page: { type: 'string', example: 1 }
            }
          }
        end
      end
    end
  end
end
