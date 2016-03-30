class GradesController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def show
    #@grade = policy_scope()
  end

  def new
  end

  def create
  end
end
