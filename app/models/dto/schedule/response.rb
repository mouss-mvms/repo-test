module Dto
  module Schedule
    class Response
      attr_accessor :day, :open_morning, :close_morning, :open_afternoon, :close_afternoon

      def initialize(**args)
        @day = args[:day]
        @open_morning = args[:open_morning]
        @open_afternoon = args[:open_afternoon]
        @close_morning = args[:close_morning]
        @close_afternoon = args[:close_afternoon]
      end

      def self.create(schedule)
        return Dto::Schedule::Response.new({
                                                   day: int_to_day(schedule.day),
                                                   open_morning: schedule.am_open&.strftime("%Hh%M") || nil,
                                                   open_afternoon: schedule.pm_open&.strftime("%Hh%M") || nil,
                                                   close_morning: schedule.am_close&.strftime("%Hh%M") || nil,
                                                   close_afternoon: schedule.pm_close&.strftime("%Hh%M") || nil
                                                 })
      end

      def to_h
        {
          day: @day,
          openMorning: @open_morning,
          openAfternoon: @open_afternoon,
          closeMorning: @close_morning,
          closeAfternoon: @close_afternoon
        }
      end

      private

      def self.int_to_day(int)
        case int
        when 1
          return "Lundi"
        when 2
          return "Mardi"
        when 3
          return "Mercredi"
        when 4
          return "Jeudi"
        when 5
          return "Vendredi"
        when 6
          return "Samedi"
        when 7
          return "Dimanche"
        else
          return nil
        end
      end
    end
  end
end
