require "test_helper"

class AccountPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#show?" do
    assert_permit(users(:henry), :account, :show)
  end

  test "#edit?" do
    assert_permit(users(:henry), :account, :edit)
  end

  test "#update" do
    assert_permit(users(:henry), :account, :update)
  end
end
