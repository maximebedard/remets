class AuthenticationsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    self.current_user = user
    redirect_to root_path
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  def failure
    render text: "Something went wrong."
  end
end
