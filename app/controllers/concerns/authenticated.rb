module Authenticated
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,
                  :signed_in?,
                  :signed_out?
  end

  def current_user
    @current_user ||= User.find(session[Remets::AUTH_SESSION_KEY]) if session[Remets::AUTH_SESSION_KEY]
  end

  def signed_in?
    !!current_user
  end

  def signed_out?
    !signed_in?
  end
end
