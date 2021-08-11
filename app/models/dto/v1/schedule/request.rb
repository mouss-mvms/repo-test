module Dto
  module V1
    module Schedule
      class Request
        attr_accessor :id, :open_morning, :open_afternoon, :close_morning, :close_afternoon

        def initialize(**args)
          @id = args[:id]
          @open_morning = args[:open_morning]
          @open_afternoon = args[:open_afternoon]
          @close_morning = args[:close_morning]
          @close_afternoon = args[:close_afternoon]
        end

        def to_h
          {
            id: id,
            open_morning: open_morning,
            open_afternoon: open_afternoon,
            close_morning: close_morning,
            close_afternoon: close_afternoon,
          }
        end
      end
    end
  end
end
