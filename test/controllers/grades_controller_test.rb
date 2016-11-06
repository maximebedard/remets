require "test_helper"

class GradesControllerTest < ActionController::TestCase
  setup do
    @grade = grades(:success)
    sign_in(users(:gaston))
  end

  test "#edit" do
    get :edit, params: { submission_id: @grade.submission.id }

    assert_response :ok
    assert assigns(:grade)
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit, params: { submission_id: @grade.submission.id }
    assert_redirected_to_auth_new
  end

  test "#update" do
    post :update, params: { submission_id: @grade.submission.id, grade: new_grade_params }

    assert_redirected_to submission_path(@grade.submission)

    @grade.reload

    assert_equal 66, @grade.result
    assert_equal "not bad mate.", @grade.comments
    assert_equal 1, @grade.graded_documents.size
  end

  test "#update is not authorized when signed out" do
    sign_out

    post :update, params: { submission_id: @grade.submission.id, grade: new_grade_params }
    assert_redirected_to_auth_new
  end

  private

  def new_grade_params
    {
      result: 66,
      comments: "not bad mate.",
      graded_document_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    }
  end
end
