require "test_helper"

class AccountPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      AccountPolicy.new(nil, nil)
    end
  end

  test "#edit? raises when not authenticated" do
    assert_permit_raises(nil, :account, :edit, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#update? raises when not authenticated" do
    assert_permit_raises(nil, :account, :update, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#edit?" do
    assert_permit(users(:henry), :account, :edit)
  end

  test "#update" do
    assert_permit(users(:henry), :account, :update)
  end
end
