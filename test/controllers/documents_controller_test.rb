require "test_helper"

class DocumentsControllerTest < ActionController::TestCase
  setup do
    @document = documents(:platypus)
    sign_in(users(:henry))
  end

  test "#download" do
    get :download, id: @document.id, extension: @document.file.extension

    assert_response :ok
    assert "plain/text", response.headers["Content-Type"]
    assert "inline; filename=\"#{@document.file_ptr.filename}\"", response.headers["Content-Disposition"]
  end

  test "#show" do
    get :show, id: @document.id

    assert_response :ok
  end

  test "#index" do
    sign_in(users(:pierre))

    get :index

    assert_response :ok
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#download is not authorized when signed out" do
    sign_out

    params = { id: @document.id, extension: @document.file.extension }
    get :download, params
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#show is not authorized when signed out" do
    sign_out

    params = { id: @document.id }
    get :show, params
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#index is not authorized when you are not an admin" do
    get :index

    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "#download is not authorized when you are not the owner nor the creator of the handover" do
    sign_in(users(:marcel))

    get :download, id: @document.id, extension: @document.file.extension
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "#show is not authorized when you are not the owner nor the creator of the handover" do
    sign_in(users(:marcel))

    get :show, id: @document.id
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end
end
