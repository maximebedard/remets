require "test_helper"

class HandoverPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      HandoverPolicy.new(nil, nil)
    end
  end

  test "#scope raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      HandoverPolicy.new(nil, handovers(:log121_lab1)).scope
    end
  end

  test "#index? raises when not authenticated" do
    assert_permit_raises(nil, handovers(:log121_lab1), :index, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#show? raises when not authenticated" do
    assert_permit_raises(nil, handovers(:log121_lab1), :show, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#edit? raises when not authenticated" do
    assert_permit_raises(nil,  handovers(:log121_lab1), :edit, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#update? raises when not authenticated" do
    assert_permit_raises(nil,  handovers(:log121_lab1), :update, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#new? raises when not authenticated" do
    assert_permit_raises(nil, handovers(:log121_lab1), :new, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#create? raises when not authenticated" do
    assert_permit_raises(nil, handovers(:log121_lab1), :create, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#index?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :index)
  end

  test "#show?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :show)
  end

  test "#edit?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :edit)
  end

  test "#update?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :update)
  end

  test "#new?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :new)
  end

  test "#create?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :create)
  end
end
