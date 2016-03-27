require "test_helper"

class ReferenceDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#download?" do
    assert_permit(users(:pierre), documents(:platypus), :download)
  end
end
