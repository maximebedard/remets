require "test_helper"

class GradePolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#show?" do
    assert_permit(users(:henry), grades(:success), :show)
  end

  test "#new?" do
    assert_permit(users(:henry), grades(:success), :new)
  end

  test "#create?" do
    assert_permit(users(:henry), grades(:success), :create)
  end
end
