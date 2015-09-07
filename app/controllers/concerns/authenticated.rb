module Authenticated
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,
                  :authenticated?
  end

  def current_user
    @current_user ||= User.find(session[:_remets_user_id]) if session[:_remets_user_id]
  end

  def authenticated?
    !!current_user
  end
end
