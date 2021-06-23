module Examples
  class Schedule
    def self.to_h
      {
        type:'object',
        properties: {
          day: {
            type: "string",
            example: "Lundi",
            description: "Day of week"
          },
          openMorning: {
            type: "string",
            example: "12h00",
            description: "Time of opening morning"
          },
          closeMorning: {
            type: "string",
            example: "12h00",
            description: "Time of closing morning"
          },
          openAfternoon: {
            type: "string",
            example: "12h00",
            description: "Time of opening afternoon"
          },
          closeAftenoon: {
            type: "string",
            example: "12h00",
            description: "Time of closing afternoon"
          },
        }
      }
    end
  end
end
