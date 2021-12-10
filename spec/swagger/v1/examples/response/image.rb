module V1
  module Examples
    module Response
      class Image
        def self.to_h
          {
            type: :object,
            properties: {
              id: { type: :integer, example: 42 },
              originalUrl: { type: :string, example: 'https://path/to/original-image.jpg'},
              miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg'},
              thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg'},
              squareUrl: { type: :string, example: 'https://path/to/square-format.jpg'},
              wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg'}
            }
          }
        end
      end
    end
  end
end