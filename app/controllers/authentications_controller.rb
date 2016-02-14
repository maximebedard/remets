class AuthenticationsController < ApplicationController
  layout "brochure"

  def new
    redirect_when_signed_in
  end

  def create
    @email = auth_params[:email]
    if @user = User.from_auth(email: @email, password: auth_params[:password])
      auth_params[:remember_me] ? remember : forget
      sign_in_and_redirect
    else
      flash.now[:danger] = "Email/Password combination does not match"
      render "new"
    end
  end

  def callback
    @user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    sign_in_and_redirect
  end

  def destroy
    forget
    self.current_user = nil
    redirect_to(root_path)
  end

  def failure
    flash[:danger] = "An error occured when authenticating with Google."
    redirect_to(root_path)
  end

  private

  def after_authenticated_path
    path = origin_path
    path = account_path if path =~ /#{auth_new_url}*/
    path
  end

  def redirect_when_signed_in
    redirect_to(root_path) if signed_in?
  end

  def sign_in_and_redirect
    self.current_user = @user
    redirect_to(after_authenticated_path)
    session.delete(Remets::ORIGIN_KEY)
  end

  def remember
    cookies.permanent.signed[Remets::AUTH_REMEMBER_KEY] = @user.id
    cookies.permanent[Remets::AUTH_REMEMBER_TOKEN] = @user.remember
  end

  def forget
    current_user.forget if signed_in?
    cookies.delete(Remets::AUTH_REMEMBER_KEY)
    cookies.delete(Remets::AUTH_REMEMBER_TOKEN)
  end

  def origin_path
    [
      session[Remets::ORIGIN_KEY],
      request.env["omniauth.origin"],
      account_path,
    ].compact.first
  end

  def auth_params
    params.require(:authentication).permit(:email, :password, :remember_me)
  end
end
