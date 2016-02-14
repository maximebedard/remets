require "test_helper"

class DocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#index? is true when an admin" do
    assert_permit(users(:pierre), Document.all, :index)
  end

  test "#index? is false when a user" do
    refute_permit(users(:gaston), Document.all, :index)
  end

  test "#show? is true when an admin" do
    assert_permit(users(:pierre), documents(:platypus), :show)
  end

  test "#show? is true when the owner of the document" do
    assert_permit(users(:henry), documents(:platypus), :show)
  end

  test "#show? is true when the owner of the handover" do
    assert_permit(users(:gaston), documents(:platypus), :show)
  end

  test "#show? is false otherwise" do
    refute_permit(users(:marcel), documents(:platypus), :show)
  end

  test "#download? is true when an admin" do
    assert_permit(users(:pierre), documents(:platypus), :download)
  end

  test "#download? is true when the owner of the document" do
    assert_permit(users(:henry), documents(:platypus), :download)
  end

  test "#download? is true when the owner of the handover" do
    assert_permit(users(:gaston), documents(:platypus), :download)
  end

  test "#download? is false otherwise" do
    refute_permit(users(:marcel), documents(:platypus), :download)
  end
end
