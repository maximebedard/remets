class Account::NotificationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
  end

  def update
  end
end
