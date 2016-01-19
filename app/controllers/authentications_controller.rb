class AuthenticationsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    self.current_user = user
    redirect_to after_authenticated_path
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  def failure
    flash[:alert] = "An error occured when authenticating with Google."
    redirect_to(root_path)
  end

  private

  def after_authenticated_path
    request.env["omniauth.origin"] || session["omniauth.origin"] || root_path
  end
end
