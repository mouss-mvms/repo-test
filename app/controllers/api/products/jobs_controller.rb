class Api::Products::JobsController < ApplicationController

    def show
        begin
            response = { :status => Sidekiq::Status::status(params[:id]), product_id: Sidekiq::Status::get(params[:id], :product_id) }
            raise ApplicationController::NotFound.new("Job not found.") if response[:status].nil?
            return render json: response, status: :ok
        end
    end
end