require "test_helper"

class HandoverPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

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

  test "#complete?" do
    assert_permit(users(:henry), handovers(:log121_lab1), :complete)
  end
end
