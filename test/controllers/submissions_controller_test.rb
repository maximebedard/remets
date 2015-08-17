require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @submission = submissions(:platypus)
  end

  test '#show' do
    get :show, id: @submission.id
    assert_response :ok
  end

  test '#create' do
  end

  test '#new' do
    get :new
    assert_response :ok
  end
end
