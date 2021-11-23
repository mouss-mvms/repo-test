module Api
  module V1
    class SelectionsController < ApplicationController
      before_action :uncrypt_token
      before_action :retrieve_user

      def create
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        dto_request = Dto::V1::Selection::Request.new(create_params)
        ActiveRecord::Base.transaction do
          begin
            selection = Selection.create!(
              {
                name: dto_request.name,
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

      def patch
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        dto_request = Dto::V1::Selection::Request.new(update_params)
        selection = Selection.find(dto_request.id)

        if dto_request.tag_ids.present?
          tags = Tag.find(dto_request.tag_ids)
          selection.tags = tags
        end

        if dto_request.image_url.present?
          set_image(object: selection, image_url: dto_request.image_url)
        end

        selection.name = dto_request.name if dto_request.name.present?
        selection.description = dto_request.description if dto_request.description.present?
        selection.begin_date = dto_request.start_at if dto_request.start_at.present?
        selection.end_date =dto_request.end_at if dto_request.end_at.present?
        selection.is_home = dto_request.home_page if dto_request.home_page
        selection.is_event = dto_request.event if dto_request.event
        selection.state = dto_request.state if dto_request.state.present?

        selection.save!

        render json: Dto::V1::Selection::Response.create(selection).to_h, status: :created
      end

      private

      def create_params
        hash = {}
        hash[:name] = params.require(:name)
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

      def update_params
        hash = {}
        hash[:id] = params[:id]
        hash[:name] = params[:name]
        hash[:description] = params[:description]
        hash[:image_url] = params[:imageUrl]
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