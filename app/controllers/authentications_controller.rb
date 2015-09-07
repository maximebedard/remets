class AuthenticationsController < ApplicationController
  def passthru
    render text: 'Provider not found.', status: :not_found
  end

  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:_remets_user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session.delete(:_remets_user_id)
    redirect_to root_path
  end

  def failure
    render text: 'Something went wrong.'
  end
end
