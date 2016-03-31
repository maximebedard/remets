class Account::ProfilesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def show
    @collection = current_user.subscribed_evaluations.upcoming.latest_deadlines_first
  end

  def edit
  end

  def update
    current_user.update(user_params)
    respond_with(current_user, location: edit_account_profile_path)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
