module Dao
  class Schedule
    def self.update(**args)
      schedules_params = OpenStruct.new(args)

      schedule = ::Schedule.find(schedules_params.id)

      return nil if (schedules_params.open_morning.nil? && !schedules_params.close_morning.nil?)

      return nil if (!schedules_params.open_morning.nil? && schedules_params.close_morning.nil?) &&
                    (schedules_params.close_afternoon.nil?)
      return nil if (schedules_params.open_afternoon.nil? && !schedules_params.close_afternoon.nil?) &&
                    (schedules_params.open_morning.nil?)

      return nil if (!schedules_params.open_afternoon.nil? && schedules_params.close_afternoon.nil?)

      return nil if (!schedules_params.open_morning.nil? && schedules_params.close_morning.nil?) &&
                    (!schedules_params.open_afternoon.nil? && !schedules_params.close_afternoon.nil?)
      return nil if (!schedules_params.open_morning.nil? && !schedules_params.close_morning.nil?) &&
                    (schedules_params.open_afternoon.nil? && !schedules_params.close_afternoon.nil?)

      continuous = (!schedules_params.open_morning.nil? && !schedules_params.close_afternoon.nil?) &&
                  (schedules_params.close_morning.nil? && schedules_params.open_afternoon.nil?)

      schedule.update!(am_open: schedules_params.open_morning,
                       am_close: schedules_params.close_morning,
                       pm_open: schedules_params.open_afternoon,
                       pm_close: schedules_params.close_afternoon,
                       continuous: continuous)

      schedule
    end
  end
end
