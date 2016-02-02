class AccountsController < ApplicationController
  respond_to :html, :json

  def edit
    authorize(:account, :edit?)
  end

  def update
    authorize(:account, :update?)
    current_user.update(user_params)
    respond_with(current_user, location: edit_account_path)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
