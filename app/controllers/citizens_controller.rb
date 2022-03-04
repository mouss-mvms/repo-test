class CitizensController < ApplicationController
  before_action :uncrypt_token
  before_action :retrieve_user
  before_action :verify_citizen_user

  private

  def verify_citizen_user
    raise ApplicationController::Forbidden unless @user.is_a_citizen?
    @citizen = @user.citizen
  end
end
