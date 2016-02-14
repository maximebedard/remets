require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#index?" do
    assert_permit(users(:henry), organizations(:ets), :index)
  end

  test "#show?" do
    assert_permit(users(:henry), organizations(:ets), :show)
  end

  test "#edit?" do
    assert_permit(users(:henry), organizations(:ets), :edit)
  end

  test "#update?" do
    assert_permit(users(:henry), organizations(:ets), :update)
  end

  test "#new?" do
    assert_permit(users(:henry), organizations(:ets), :new)
  end

  test "#create?" do
    assert_permit(users(:henry), organizations(:ets), :create)
  end
end
