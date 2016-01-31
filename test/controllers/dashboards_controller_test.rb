require "test_helper"

class DashboardsControllerTest < ActionController::TestCase
  test "#index" do
    get :index
    assert_response :success
  end
end
