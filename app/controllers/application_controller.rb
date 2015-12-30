class ApplicationController < ActionController::Base
  include Pundit
  include Authenticated

  protect_from_forgery with: :exception
end
