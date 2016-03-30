require "test_helper"

class BoilerplateDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#download?" do
    assert_permit(users(:pierre), boilerplate_documents(:platypus_boilerplate), :download)
  end
end
