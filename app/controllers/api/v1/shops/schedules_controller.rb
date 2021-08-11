module Api
  module V1
    module Shops
      class SchedulesController < ApplicationController
        before_action :uncrypt_token, only: [:update]
        before_action :retrieve_user, only: [:update]

        def index
          response = []
          Shop.find(params[:id]).schedules.each do |schedule|
            response << Dto::V1::Schedule::Response.create(schedule)
          end
          return render json: response, status: :ok
        end

        def update
          raise ApplicationController::Forbidden.new('') unless @user.is_a_business_user?
          shop = Shop.find(params['id'])
          raise ApplicationController::Forbidden.new('') unless @user.shop_employee.shops.to_a.find { |s| s.id == shop.id}
          response = []
          schedules_params.each do |schedule_param|
            dto = Dto::V1::Schedule::Request.new(schedule_param)
            shop.schedules.find(dto.id)
            schedule_updated = Dao::Schedule::update(dto.to_h)
            response << Dto::V1::Schedule::Response.create(schedule_updated).to_h
          end

          return render json: response, status: :ok
        end

        def schedules_params
          schedules_params = []
          params[:_json].each do |schedule|
            schedules_params << {
              id: schedule.require(:id),
              open_morning: schedule["openMorning"],
              open_afternoon: schedule["openAfternoon"],
              close_morning: schedule["closeMorning"],
              close_afternoon: schedule["closeAfternoon"],
            }
          end
          schedules_params
        end
      end
    end
  end
end
