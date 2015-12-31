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
end
