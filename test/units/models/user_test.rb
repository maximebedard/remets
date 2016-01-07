require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#user?" do
    assert users(:gaston).user?
    refute users(:pierre).user?
  end

  test "#admin?" do
    refute users(:gaston).admin?
    assert users(:pierre).admin?
  end
end
