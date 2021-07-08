class ApplicationController < ActionController::API
  Forbidden = Class.new(ActionController::ActionControllerError)

  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActionController::ParameterMissing , with: :render_bad_request
  rescue_from ApplicationController::Forbidden, with: :render_forbidden

  def render_record_not_found(exception)
    Rails.logger.error(exception)
    error = Dto::Errors::NotFound.new(detail: exception.message)
    render error.to_json, status: error.status
  end

  def render_bad_request(exception)
    Rails.logger.error(exception)
    error = Dto::Errors::BadRequest.new(detail: exception.message)
    render error.to_json, status: error.status
  end

  def render_forbidden(exception)
    Rails.logger.error(exception)
    error = Dto::Errors::Forbidden.new(detail: exception.message)
    render error.to_json, status: error.status
  end

  def uncrypt_token
    unless request.headers[:HTTP_X_CLIENT_ID] && request.headers[:HTTP_X_CLIENT_ID].present?
      error = Dto::Errors::Unauthorized.new
      return render json: error.to_h, status: error.status
    end
    begin
      @uncrypted_token = JWT.decode(request.headers[:HTTP_X_CLIENT_ID], ENV["JWT_SECRET"], true, {algorithm: 'HS256'})
    rescue JWT::DecodeError => e
      Rails.logger.error(e)
      error = Dto::Errors::InternalServer.new("Enable to decrypt token")
      return render json: error.to_h, status: error.status
    end
  end

  def retrieve_user
    begin
      @user = User.find(@uncrypted_token.first['id'])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e)
      error = Dto::Errors::Forbidden.new
      return render json: error.to_h, status: error.status
    end
  end
end
