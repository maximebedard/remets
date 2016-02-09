require "test_helper"

class SubmissionPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      SubmissionPolicy.new(nil, nil)
    end
  end

  test "#scope raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      SubmissionPolicy.new(nil, submissions(:log121_lab1_1)).scope
    end
  end

  test "#index? raises when not authenticated" do
    assert_permit_raises(nil, submissions(:log121_lab1_1), :index, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#show? raises when not authenticated" do
    assert_permit_raises(nil, submissions(:log121_lab1_1), :show, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#new? raises when not authenticated" do
    assert_permit_raises(nil, submissions(:log121_lab1_1), :new, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#create? raises when not authenticated" do
    assert_permit_raises(nil, submissions(:log121_lab1_1), :create, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#index?" do
    assert_permit(users(:henry), submissions(:log121_lab1_1), :index)
  end

  test "#show?" do
    assert_permit(users(:henry), submissions(:log121_lab1_1), :show)
  end

  test "#new?" do
    assert_permit(users(:henry), submissions(:log121_lab1_1), :new)
  end

  test "#create?" do
    assert_permit(users(:henry), submissions(:log121_lab1_1), :create)
  end
end
