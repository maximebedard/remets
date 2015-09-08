require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @submission = submissions(:log121_lab1)
  end

  test '#index' do
    get :index

    assert assigns(:submissions)
    assert_response :ok
  end

  test '#show' do
    get :show, id: @submission.id

    assert assigns(:submission)
    assert_response :ok
  end

  test '#create' do
    document_fixture = fixture_file_upload('files/documents/file/605975481/text_document1.txt')

    post :create, submission: {
      documents_attributes: [document_fixture]
    }

    assert_redirected_to assigns(:submission)
  end

  test '#new' do
    get :new

    assert assigns(:submission)
    assert_response :ok
  end

  test '#index with json' do
    skip
  end

  test '#show with json' do
    skip
  end

  test '#create with json' do
    skip
  end

  test '#new with json' do
    skip
  end
end
