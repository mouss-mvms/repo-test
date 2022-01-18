module Dto
  module V1
    module Citizen
      class Response
        attr_reader :id, :nick_name

        def initialize(**args)
          @id = args[:id]
          @nick_name = args[:nick_name]
        end

        def self.create(citizen)
          return nil unless citizen

          new({ id: citizen.id, nick_name: citizen.nickname })
        end

        def to_h
          {
            id: @id,
            nickName: @nick_name
          }
        end
      end
    end
  end
end
