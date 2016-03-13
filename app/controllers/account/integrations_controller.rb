class Account::IntegrationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
  end

  def update
  end
end
