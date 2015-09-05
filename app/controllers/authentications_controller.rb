class AuthenticationsController < ApplicationController
  AUTH_SESSION_KEY = :_remets_user_id

  def create
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    redirect_to root_path
  end

  def destroy
    session.delete(AUTH_SESSION_KEY)
    redirect_to root_path
  end

  def failure
    render text: 'damn...'
  end
end
