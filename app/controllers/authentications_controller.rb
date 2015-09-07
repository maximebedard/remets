class AuthenticationsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    session[:_remets_user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    session.delete(:_remets_user_id)
    redirect_to root_path
  end

  def failure
    render text: 'damn...'
  end
end
