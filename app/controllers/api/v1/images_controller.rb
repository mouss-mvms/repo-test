require_relative '../../../models/dto/v1/image/request.rb'

module Api
  module V1
    class ImagesController < ApplicationController
      before_action :uncrypt_token, only: [:create]
      before_action :retrieve_user, only: [:create]

      def create
        threads = []
        files = params[:files]
        begin
          files.each do |file|
            threads << Thread.new {
              raise ApplicationController::UnpermittedParameter.new("Incorrect File Format") unless file.is_a?(ActionDispatch::Http::UploadedFile)
              image_dto = Dto::V1::Image::Request.create(image: file)
              Rails.application.executor.wrap do # Avoid Circular dependency detected while autoloading constant Image
                image = Image.create!(file: image_dto.tempfile)
                image.save
                Thread.current["image_id"] = image.id
              end
            }
          end
        rescue StandardError => e
          raise ApplicationController::InternalServerError.new(e.message)
        else
          image_ids = ActiveSupport::Dependencies.interlock.permit_concurrent_loads do # Enable Image to be invoked by multiple threads at the same time
            threads.map { |thread| thread.join(); thread[:image_id] }
          end
          response = Image.where(id: image_ids).map { |image| Dto::V1::Image::Response.create(image).to_h }
          render json: response, status: :created
        end
      end
    end
  end
end
