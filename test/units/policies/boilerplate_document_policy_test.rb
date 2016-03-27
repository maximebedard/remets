require "test_helper"

class BoilerplateDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#download?" do
    assert_permit(users(:pierre), documents(:platypus), :download)
  end
end
