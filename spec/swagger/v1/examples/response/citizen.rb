module V1
  module Examples
    module Response
      class Citizen
        def self.to_h
          {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 15,
                description: 'Id of citizen'
              },
              nickName: {
                type: 'string',
                example: 'nick name',
                description: 'Nickname of citizen'
              }
            }
          }
        end
      end
    end
  end
end

