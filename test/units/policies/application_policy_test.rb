require "test_helper"

class ApplicationPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  setup do
    @policy = ApplicationPolicy.new(
      users(:henry),
      documents(:platypus),
    )
  end

  test "#index?" do
    refute @policy.index?
  end

  test "#show?" do
    assert @policy.show?
  end

  test "#create?" do
    refute @policy.create?
  end

  test "#new?" do
    refute @policy.new?
  end

  test "#update?" do
    refute @policy.update?
  end

  test "#edit?" do
    refute @policy.edit?
  end

  test "#destroy" do
    refute @policy.destroy?
  end

  test "#scope" do
    assert_equal Document, @policy.scope
  end

  test "#authenticated?" do
    assert @policy.authenticated?
  end

  test "#authenticated? is false when the current user is nil" do
    @policy = ApplicationPolicy.new(
      nil,
      documents(:platypus),
    )

    refute @policy.authenticated?
  end

  test "#authenticate!" do
    assert_nil @policy.authenticate!
  end

  test "#authenticate! raises when the current user is nil" do
    @policy = ApplicationPolicy.new(
      nil,
      documents(:platypus),
    )

    assert_raises(Remets::NotAuthenticatedError) do
      @policy.authenticate!
    end
  end
end
