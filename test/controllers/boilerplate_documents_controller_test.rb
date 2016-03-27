require "test_helper"

class BoilerplateDocumentsControllerTest < ActionController::TestCase
  setup do
    @document = boilerplate_documents(:platypus_boilerplate)
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
end
