module Authenticated
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,
                  :signed_in?,
                  :signed_out?
  end

  def current_user
    @current_user ||= User.find_by(id: session[Remets::AUTH_SESSION_KEY])
  end

  def current_user=(value)
    @current_user = value
    session[Remets::AUTH_SESSION_KEY] = value.nil? ? nil : value.id
  end

  def signed_in?
    !!current_user
  end

  def signed_out?
    !signed_in?
  end
end
