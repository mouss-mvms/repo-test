module Api
  module Shops
    class SchedulesController < ApplicationController
      def index
        schedules = Shop.find(params[:id]).schedules
        response = []
        schedules.each do |schedule|
          response << Dto::Schedule::Response.create(schedule)
        end
        return render json: response, status: :ok
      end
    end
  end
end
