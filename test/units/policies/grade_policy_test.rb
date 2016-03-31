require "test_helper"

class GradePolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#edit?" do
    assert_permit(users(:henry), grades(:success), :edit)
  end

  test "#update?" do
    assert_permit(users(:henry), grades(:success), :update)
  end
end
