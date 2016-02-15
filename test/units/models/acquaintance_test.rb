require "test_helper"

class AcquaintanceTest < ActiveSupport::TestCase
  setup do
    Rails.cache.clear
    @user = users(:gaston)
  end

  test ".load_from_cache" do
    Rails.cache.write("acquaintances:#{@user.id}", "pants.")

    assert_equal "pants.", Acquaintance.load_from_cache(@user)
  end

  test ".load_from_cache queues an AcquaintanceFindingJob on cache miss" do
    assert_enqueued_with(job: AcquaintanceFindingJob, queue: "default") do
      assert_equal [], Acquaintance.load_from_cache(@user)
      assert_equal nil, Rails.cache.read("acquaintances:#{@user.id}")
    end
  end

  test ".save_to_cache" do
    Acquaintance.save_to_cache(@user, "pants.")

    assert Rails.cache.exist?("acquaintances:#{@user.id}")
  end

  test ".save_to_cache expires after 1 day" do
    Acquaintance.save_to_cache(@user, "pants.")

    travel_to(2.days.from_now) do
      refute Rails.cache.exist?("acquaintances:#{@user.id}")
    end
  end
end
