require "test_helper"

class DocumentMatchPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  setup do
    @document_match = DocumentMatch.new
  end

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      DocumentMatchPolicy.new(nil, nil)
    end
  end

  test "#show? is true when an admin" do
    assert_permit(users(:pierre), @document_match, :show)
  end

  test "#show? raises when not authenticated" do
    assert_permit_raises(nil, @document_match, :show, ApplicationPolicy::NotAuthenticatedError)
  end
end
