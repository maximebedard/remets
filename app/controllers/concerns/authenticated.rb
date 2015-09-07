module Authenticated
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,
                  :signed_in?,
                  :signed_out?
  end

  def current_user
    @current_user ||= User.find(session[:_remets_user_id]) if session[:_remets_user_id]
  end

  def signed_in?
    !!current_user
  end

  def signed_out?
    !signed_in?
  end
end
