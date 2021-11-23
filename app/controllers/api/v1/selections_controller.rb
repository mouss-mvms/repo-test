module Api
  module V1
    class SelectionsController < ApplicationController
      before_action :uncrypt_token, only: [:create]
      before_action :retrieve_user, only: [:create]

      def index
        selections = Selection.online
        render json: selections.map { |selection| Dto::V1::Selection::Response.create(selection).to_h }, status: :ok
      end

      def show
        selection = Selection.find(params[:id])
        raise ApplicationController::Forbidden.new('Selection not online.') unless Selection.online.include?(selection)

        response = Dto::V1::Selection::Response.create(selection).to_h
        render json: response, status: :ok
      end

      def create
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        dto_request = Dto::V1::Selection::Request.new(create_params)
        ActiveRecord::Base.transaction do
          begin
            selection = Selection.create!(
              {
                name: dto_request.name,
                slug: dto_request.slug,
                description: dto_request.description,
                begin_date: dto_request.start_at,
                end_date: dto_request.end_at,
                is_home: dto_request.home_page,
                is_event: dto_request.event,
                state: dto_request.state
              }
            )

            set_image(object: selection, image_url: dto_request.image_url)

            if dto_request.image_url.present?
              tags = ::Tag.find(dto_request.tag_ids)
              selection.tags = tags
            end

            selection.save!
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error(e)
            error = Dto::Errors::NotFound.new(e.message)
            return render json: error.to_h, status: error.status
          rescue ActiveRecord::RecordNotSaved, ArgumentError => e
            Rails.logger.error(e)
            error = Dto::Errors::UnprocessableEntity.new(e.message)
            return render json: error.to_h, status: error.status
          rescue => e
          else
            return render json: Dto::V1::Selection::Response.create(selection).to_h, status: :created
          end
        end
      end

      def create_params
        hash = {}
        hash[:name] = params.require(:name)
        hash[:slug] = params.require(:slug)
        hash[:description] = params.require(:description)
        hash[:image_url] = params.require(:imageUrl)
        hash[:tag_ids] = params[:tagIds]
        hash[:start_at] = params[:startAt]
        hash[:end_at] = params[:endAt]
        hash[:home_page] = params[:homePage]
        hash[:event] = params[:event]
        hash[:state] = params[:state]
        hash
      end

      def set_image(object:, image_url:)
        begin
          image = Shrine.remote_url(image_url)
          object.image = Image.create(file: image)
        rescue StandardError => e
          Rails.logger.error(e)
          Rails.logger.error(e.message)
        end
      end
    end
  end
end