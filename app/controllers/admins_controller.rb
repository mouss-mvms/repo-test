class AdminsController < ApplicationController
  before_action :uncrypt_token
  before_action :retrieve_user
  before_action :verify_admin

  private

  def verify_admin
    raise ApplicationController::Forbidden unless @user.is_an_admin?
  end
end