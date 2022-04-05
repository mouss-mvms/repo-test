module Api
  module V1
    class SelectionsController < ApplicationController
      before_action :uncrypt_token, only: [:create, :patch, :destroy]
      before_action :retrieve_user, only: [:create, :patch, :destroy]

      def index
        params[:limit] ||= Pagy::DEFAULT[:items].to_i
        pagination, selections = pagy(Selection.online, items: params[:limit])
        response = { selections: selections.map { |selection| Dto::V1::Selection::Response.create(selection).to_h }, page: pagination.page, totalPages: pagination.pages, totalCount: pagination.count }
        render json: response, status: :ok
      end

      def show
        selection = Selection.find(params[:id])
        raise ApplicationController::Forbidden unless Selection.online.include?(selection)

        response = Dto::V1::Selection::Response.create(selection).to_h
        render json: response, status: :ok
      end

      def create
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        dto_request = Dto::V1::Selection::Request.new(create_params)
        ActiveRecord::Base.transaction do
          begin
            selection = Dao::Selection.create(dto_selection_request: dto_request)
          rescue ActiveRecord::RecordNotFound => e
            raise ApplicationController::NotFound.new(e)
          rescue ActiveRecord::RecordNotSaved, ArgumentError => e
            raise ApplicationController::UnprocessableEntity.new(e)
          else
            return render json: Dto::V1::Selection::Response.create(selection).to_h, status: :created
          end
        end
      end

      def patch
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        dto_request = Dto::V1::Selection::Request.new(update_params)
        selection = Dao::Selection.update(dto_selection_request: dto_request)
        render json: Dto::V1::Selection::Response.create(selection).to_h, status: :ok
      end

      def destroy
        raise ApplicationController::Forbidden.new unless @user.is_an_admin?
        selection = Selection.find(params[:id])
        selection.destroy!
      end

      private

      def create_params
        hash = {}
        hash[:name] = params.require(:name)
        hash[:description] = params.require(:description)
        if params[:imageId]
          hash[:image_id] = params.require(:imageId) if Image.find(params[:imageId])
        elsif params[:imageUrl]
          hash[:image_url] = params.require(:imageUrl)
        else
          raise ActionController::ParameterMissing.new('imageId or imageUrl')
        end
        hash[:tag_ids] = params[:tagIds]
        hash[:start_at] = params[:startAt]
        hash[:end_at] = params[:endAt]
        hash[:home_page] = params[:homePage]
        hash[:event] = params[:event]
        hash[:state] = params[:state]
        hash[:cover_url] = params[:coverUrl]
        hash[:cover_id] = params[:coverId]
        hash[:promoted] = params[:promoted]
        hash
      end

      def update_params
        hash = {}
        hash[:id] = params[:id]
        hash[:name] = params[:name]
        hash[:description] = params[:description]
        if params[:imageId]
          hash[:image_id] = params[:imageId] if Image.find(params[:imageId])
        elsif params[:imageUrl]
          hash[:image_url] = params[:imageUrl]
        end
        hash[:tag_ids] = params[:tagIds]
        hash[:start_at] = params[:startAt]
        hash[:end_at] = params[:endAt]
        hash[:home_page] = params[:homePage]
        hash[:event] = params[:event]
        hash[:state] = params[:state]
        hash[:cover_url] = params[:coverUrl]
        hash[:cover_id] = params[:coverId]
        hash[:promoted] = params[:promoted]
        hash
      end
    end
  end
end