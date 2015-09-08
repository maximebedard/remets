class AuthenticationsController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[Remets::AUTH_SESSION_KEY] = user.id
    redirect_to root_path
  end

  def destroy
    session.delete(Remets::AUTH_SESSION_KEY)
    redirect_to root_path
  end

  def failure
    render text: 'Something went wrong.'
  end
end
