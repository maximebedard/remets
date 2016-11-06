require "test_helper"

class AcquaintancesControllerTest < ActionController::TestCase
  setup do
    @user = users(:gaston)
    sign_in(@user)
  end

  test "#index" do
    Acquaintance.save_to_cache(@user, [Acquaintance.new(
      name: "Henry Lemieux",
      email: "henry@lemieux.com",
      provider: "google",
    )])

    get :index, params: { format: :json }

    assert_response :ok
    assert_equal([{
      "email" => "henry@lemieux.com",
      "name" => "Henry Lemieux",
      "provider" => "google",
    }], JSON.parse(response.body))
  end

  test "#index queues an AcquaintanceFindingJob on cache miss" do
    Rails.cache.clear

    assert_enqueued_with(job: AcquaintanceFindingJob, queue: "default") do
      get :index, params: { format: :json }
    end

    assert_equal [], JSON.parse(response.body)
  end
end
