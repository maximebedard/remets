require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      OrganizationPolicy.new(nil, nil)
    end
  end

  test "#scope raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      OrganizationPolicy.new(nil, organizations(:ets)).scope
    end
  end

  test "#index? raises when not authenticated" do
    assert_permit_raises(nil, organizations(:ets), :index, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#show? raises when not authenticated" do
    assert_permit_raises(nil, organizations(:ets), :show, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#edit? raises when not authenticated" do
    assert_permit_raises(nil,  organizations(:ets), :edit, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#update? raises when not authenticated" do
    assert_permit_raises(nil,  organizations(:ets), :update, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#new? raises when not authenticated" do
    assert_permit_raises(nil, organizations(:ets), :new, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#create? raises when not authenticated" do
    assert_permit_raises(nil, organizations(:ets), :create, ApplicationPolicy::NotAuthenticatedError)
  end

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
