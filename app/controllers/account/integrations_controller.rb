class Account::IntegrationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
  end

  def new
  end
end
