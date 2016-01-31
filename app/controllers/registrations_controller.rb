class RegistrationsController < ApplicationController
  respond_to :html, :json

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    respond_with(@user, location: dashboards_path)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
