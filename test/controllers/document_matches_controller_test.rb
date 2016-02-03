require "test_helper"

class DocumentMatchesControllerTest < ActionController::TestCase
  setup do
    document1 =
      documents(:platypus).tap do |doc|
        doc.update!(windows: [[0, 1234], [1, 5678], [2, 0000]])
      end

    document2 =
      documents(:fraudulent_platypus).tap do |doc|
        doc.update!(windows: [[0, 5678], [1, 0000]])
      end

    @document_match, * = DocumentMatch.create_from!(document1, document2)
    sign_in(users(:pierre))
  end

  test "#show" do
    get :show, id: @document_match.id
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out
    params = { id: @document_match.id }

    get :show, params
    assert_redirected_to auth_authorize_path(:google, origin: document_match_url(params))
  end

  test "#show is not authorized when not an admin" do
    sign_in(users(:henry))
    params = { id: @document_match.id }

    get :show, params
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:danger]
  end
end
