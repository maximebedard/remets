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

  test "#download with the incorrect extension" do
    get :download, id: @document.id, extension: "pdf"

    assert_response :not_found
  end

  test "#show" do
    get :show, id: @document.id

    assert_response :ok
  end

  test "#download is not authorized when signed out" do
    sign_out

    assert_raises(Pundit::NotAuthorizedError) do
      get :download, id: @document.id, extension: @document.file.extension
    end
  end

  test "#show is not authorized when signed out" do
    sign_out

    assert_raises(Pundit::NotAuthorizedError) do
      get :show, id: @document.id
    end
  end

  test "#download is not authorized when you are not the owner not the creator of the handover" do
    sign_in(users(:marcel))

    assert_raises(Pundit::NotAuthorizedError) do
      get :download, id: @document.id, extension: @document.file.extension
    end
  end

  test "#show is not authorized when you are not the owner not the creator of the handover" do
    sign_in(users(:marcel))

    assert_raises(Pundit::NotAuthorizedError) do
      get :show, id: @document.id
    end
  end
end
