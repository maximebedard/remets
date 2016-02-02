class AuthenticationsController < ApplicationController
  def new
  end

  def create
    @email = auth_params[:email]
    if @user = User.from_auth(email: @email, password: auth_params[:password])
      sign_in_and_redirect(dashboards_path)
    else
      flash.now[:alert] = "Email/Password combination does not match"
      render "new"
    end
  end

  def callback
    @user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect
  end

  def destroy
    self.current_user = nil
    redirect_to(root_path)
  end

  def failure
    flash[:alert] = "An error occured when authenticating with Google."
    redirect_to(root_path)
  end

  private

  def after_authenticated_path
    request.env["omniauth.origin"] || session["omniauth.origin"] || root_path
  end

  def sign_in_and_redirect(path = after_authenticated_path)
    self.current_user = @user
    redirect_to(path)
  end

  def auth_params
    params.require(:authentication).permit(:email, :password)
  end
end
