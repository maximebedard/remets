class Account::SecuritiesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def edit
  end

  def update
  end
end
