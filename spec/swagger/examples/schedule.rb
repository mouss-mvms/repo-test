module Examples
  class Schedule
    def self.to_h
      {
        type: 'object',
        properties: {
          id: {
            type: "integer",
            example: 3,
            description: "Id of schedules"
          },
          day: {
            type: "string",
            example: "Lundi",
            description: "Day of week"
          },
          openMorning: {
            type: "string",
            example: "09:00",
            description: "Time of opening morning"
          },
          closeMorning: {
            type: "string",
            example: "12:00",
            description: "Time of closing morning"
          },
          openAfternoon: {
            type: "string",
            example: "14:00",
            description: "Time of opening afternoon"
          },
          closeAftenoon: {
            type: "string",
            example: "19:00",
            description: "Time of closing afternoon"
          },
        }
      }
    end
  end
end
