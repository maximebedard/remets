require 'test_helper'

class HandoversControllerTest < ActionController::TestCase
  setup do
    @handover = handovers(:log121_lab1)
  end

  test '#index' do
    get :index
    assert_response :ok
  end

  test '#show' do
    get :show, id: @handover.id
    assert_response :ok
  end

  test '#new' do
    get :new
    assert_response :ok
  end

  test '#create' do
  end

  test '#edit' do
  end

  test '#update' do
  end


  test '#index with json'
  test '#show with json'
  test '#new with json'
  test '#create with json'
  test '#edit with json'
  test '#update with json'
end
