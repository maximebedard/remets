require "test_helper"

class ReferenceDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#download?" do
    assert_permit(users(:pierre), reference_documents(:platypus_reference), :download)
  end
end
