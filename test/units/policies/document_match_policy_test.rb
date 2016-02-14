require "test_helper"

class DocumentMatchPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  setup do
    @document_match = DocumentMatch.new
  end

  test "#show? is true when an admin" do
    assert_permit(users(:pierre), @document_match, :show)
  end
end
