require "test_helper"

class DocumentsControllerTest < ActionController::TestCase
  setup do
    @document = documents(:platypus)
    @compared_document = documents(:fraudulent_platypus)
    sign_in(users(:henry))
  end

  test "#download" do
    get :download, id: @document.id, extension: @document.file.extension

    assert_response :ok
    assert "plain/text", response.headers["Content-Type"]
    assert "inline; filename=\"#{@document.file_ptr.filename}\"", response.headers["Content-Disposition"]
  end

  test "#download is not authorized when signed out" do
    sign_out

    params = { id: @document.id, extension: @document.file.extension }
    get :download, params
    assert_redirected_to_auth_new
  end

  test "#download is not authorized when you are not the owner nor the creator of the handover" do
    sign_in(users(:marcel))

    get :download, id: @document.id, extension: @document.file.extension
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:danger]
  end

  test "#show" do
    get :show, id: @document.id

    assert assigns(:document)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, id: @document.id
    assert_redirected_to_auth_new
  end

  test "#show is not authorized when you are not the owner nor the creator of the handover" do
    sign_in(users(:marcel))

    get :show, id: @document.id
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:danger]
  end

  test "#diff" do
    get :diff, id: @document.id, compared_id: @compared_document.id

    assert assigns(:reference)
    assert assigns(:compared)

    assert_response :ok
  end

  test "#diff is not authorized when signed out" do
    sign_out

    get :diff, id: @document.id, compared_id: @compared_document.id
    assert_redirected_to_auth_new
  end
end
