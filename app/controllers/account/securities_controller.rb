class Account::SecuritiesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
  end

  def update
    current_user.update(user_params)
    respond_with(current_user, location: edit_account_security_path)
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
