require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @submission = submissions(:log121_lab1)
  end

  test '#show' do
    get :show, id: @submission.id
    assert_response :ok
  end

  test '#create' do
    fixture = fixture_file_upload('files/documents/file/605975481/text_document1.txt')

    post :create, submission: {
      documents_attributes: [fixture]
    }

    assert_response :created
  end

  test '#new' do
    get :new
    assert_response :ok
  end
end
