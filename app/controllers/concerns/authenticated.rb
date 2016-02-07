module Authenticated
  extend ActiveSupport::Concern

  included do
    helper_method :current_user,
      :signed_in?,
      :signed_out?
  end

  def current_user
    @current_user ||= user_from_session
    @current_user ||= user_from_cookies
  end

  def current_user=(value)
    @current_user = value
    session[Remets::AUTH_SESSION_KEY] = value.nil? ? nil : value.id
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_out?
    !signed_in?
  end

  private

  def user_from_session
    User.find_by(id: session[Remets::AUTH_SESSION_KEY])
  end

  def user_from_cookies
    user = User.find_by(id: cookies.signed[Remets::AUTH_REMEMBER_KEY])
    return unless user && user.remembered?(cookies[Remets::AUTH_REMEMBER_TOKEN])

    self.current_user = user
    user
  end
end
