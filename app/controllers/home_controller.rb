class HomeController < ApplicationController
  layout "brochure"

  def index
    @user = User.new
  end
end
