require "test_helper"

class GradedDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#download?" do
    assert_permit(users(:pierre), graded_documents(:successful_platypus), :download)
  end
end
