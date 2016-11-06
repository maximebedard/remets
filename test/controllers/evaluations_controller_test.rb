require "test_helper"

class EvaluationsControllerTest < ActionController::TestCase
  setup do
    @evaluation = evaluations(:log121_lab1)
    sign_in users(:gaston)
  end

  test "#index" do
    get :index

    assert assigns(:evaluations)
    assert_response :ok
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index
    assert_redirected_to_auth_new
  end

  test "#show" do
    get :show, params: { uuid: @evaluation.uuid }

    assert assigns(:evaluation)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, params: { uuid: @evaluation.uuid }
    assert_redirected_to_auth_new
  end

  test "#edit" do
    get :edit, params: { uuid: @evaluation.uuid }

    assert assigns(:evaluation)
    assert_response :ok
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit, params: { uuid: @evaluation.uuid }
    assert_redirected_to_auth_new
  end

  test "#update" do
    travel_to(Time.zone.now) do
      patch :update, params: { uuid: @evaluation.uuid, evaluation: {
        title: "pants",
        description: "pants pants pants",
        due_date: 5.days.from_now,
        organization: organizations(:ets).id,
        reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
        boilerplate_documents_attriubtes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      } }
      evaluation = assigns(:evaluation)
      assert_equal "pants", evaluation.title
      assert_equal "pants pants pants", evaluation.description
      assert_equal 5.days.from_now, evaluation.due_date
      assert_equal "École de technologie supérieure", evaluation.organization.name
      assert_equal 2, evaluation.reference_documents.size
      assert_equal 4, evaluation.boilerplate_documents.size
      assert_redirected_to evaluation_path(uuid: evaluation.uuid)
    end
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, params: { uuid: @evaluation.uuid, evaluation: {
      title: "pants",
      description: "pants pants pants",
      due_date: 5.days.from_now,
      organization: organizations(:ets).id,
      reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      boilerplate_documents_attriubtes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    } }
    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new

    assert assigns(:evaluation)
    assert_response :ok
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new
    assert_redirected_to_auth_new
  end

  test "#create" do
    travel_to(Time.zone.now) do
      post :create, params: { evaluation: {
        title: "pants",
        description: "pants pants pants",
        due_date: 5.days.from_now,
        organization: organizations(:ets).id,
        subscriptions: ["idont@exists.com"],
        reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
        boilerplate_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      } }

      evaluation = assigns(:evaluation)
      assert_equal "pants", evaluation.title
      assert_equal "pants pants pants", evaluation.description
      assert_equal 5.days.from_now, evaluation.due_date
      assert_equal "École de technologie supérieure", evaluation.organization.name
      assert_equal 1, evaluation.reference_documents.size
      assert_equal 1, evaluation.boilerplate_documents.size
      assert_equal 1, evaluation.subscriptions.size
      assert_equal "idont@exists.com", evaluation.users.first.email
      assert_redirected_to evaluation_path(uuid: evaluation.uuid)
    end
  end

  test "#create invite new subscribers" do
    assert_difference("User.count") do
      post :create, params: { evaluation: {
        title: "pants",
        description: "pants pants pants",
        due_date: 5.days.from_now,
        organization: organizations(:ets).id,
        subscriptions: ["idont@exists.com"],
        reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
        boilerplate_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      } }
      assert_redirected_to evaluation_path(uuid: assigns(:evaluation).uuid)
    end
  end

  test "#create does not invite new subscribers when invalid" do
    assert_no_difference("User.count") do
      post :create, params: { evaluation: {
        subscriptions: ["idont@exists.com"],
      } }
      assert_template "new"
    end
  end

  test "#create is not authorized when signed out" do
    sign_out

    post :create, params: { evaluation: {
      title: "pants",
      description: "pants pants pants",
      due_date: 5.days.from_now,
      reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    } }
    assert_redirected_to_auth_new
  end

  test "#complete" do
    travel_to(Time.zone.now) do
      patch :complete, params: { uuid: @evaluation.uuid }
      evaluation = assigns(:evaluation)
      assert_equal Time.zone.now, evaluation.mark_as_completed
      assert_redirected_to evaluation_path(uuid: evaluation.uuid)
    end
  end

  test "#complete is not authorized when signed out" do
    sign_out

    patch :complete, params: { uuid: @evaluation.uuid }
    assert_redirected_to_auth_new
  end
end
