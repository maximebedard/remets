class ApplicationController < ActionController::Base
  include Authentication

  rescue_from Remets::NotAuthenticationError, with: :user_must_be_authenticated

  protect_from_forgery with: :exception

  private

  def user_must_be_authenticated
    session[Remets::ORIGIN_KEY] = request.original_url
    redirect_to auth_new_path
  end

  def user_not_authorized
    flash[:danger] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
