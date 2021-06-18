class ApplicationController < ActionController::API
  def uncrypt_token
    unless request.headers[:HTTP_X_CLIENT_ID] && request.headers[:HTTP_X_CLIENT_ID].present?
      error = Dto::Errors::Unauthorized.new
      return render json: error.to_h, status: error.status
    end
    begin
      @uncrypted_token = JWT.decode(request.headers[:HTTP_X_CLIENT_ID], ENV["JWT_SECRET"], true, {algorithm: 'HS256'})
    rescue JWT::DecodeError
      error = Dto::Errors::InternalServer.new
      return render json: error.to_h, status: error.status
    end
  end

  def retrieve_user
    begin
      @user = User.find(@uncrypted_token.first['id'])
    rescue ActiveRecord::RecordNotFound
      error = Dto::Errors::Forbidden.new
      return render json: error.to_h, status: error.status
    end

    unless @user.is_a_pro?
      error = Dto::Errors::Forbidden.new
      return render json: error.to_h, status: error.status
    end

    unless @user.is_an_admin? || (@shop.owner == @user.shop_employee)
      error = Dto::Errors::Forbidden.new
      return render json: error.to_h, status: error.status
    end
  end

end
