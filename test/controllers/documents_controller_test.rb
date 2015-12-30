require "test_helper"

class DocumentsControllerTest < ActionController::TestCase
  setup do
    @document = documents(:platypus)
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
end
