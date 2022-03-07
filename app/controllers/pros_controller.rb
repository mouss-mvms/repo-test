class ProsController < ApplicationController
  before_action :uncrypt_token
  before_action :retrieve_user
  before_action :verify_business_user

  private

  def verify_business_user
    raise ApplicationController::Forbidden unless @user.is_a_business_user?
  end
end
