require "test_helper"

class SubmissionPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

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
