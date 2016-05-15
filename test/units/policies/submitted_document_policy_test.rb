require "test_helper"

class SubmittedDocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#show? is true when an admin" do
    assert_permit(users(:pierre), submitted_documents(:platypus), :show)
  end

  test "#show? is true when the owner of the document" do
    assert_permit(users(:henry), submitted_documents(:platypus), :show)
  end

  test "#show? is true when the owner of the evaluation" do
    assert_permit(users(:gaston), submitted_documents(:platypus), :show)
  end

  test "#show? is false otherwise" do
    refute_permit(users(:marcel), submitted_documents(:platypus), :show)
  end

  test "#download? is true when an admin" do
    assert_permit(users(:pierre), submitted_documents(:platypus), :download)
  end

  test "#download? is true when the owner of the document" do
    assert_permit(users(:henry), submitted_documents(:platypus), :download)
  end

  test "#download? is true when the owner of the evaluation" do
    assert_permit(users(:gaston), submitted_documents(:platypus), :download)
  end

  test "#download? is false otherwise" do
    refute_permit(users(:marcel), submitted_documents(:platypus), :download)
  end
end
