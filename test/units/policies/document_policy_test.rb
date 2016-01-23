require "test_helper"

class DocumentPolicyTest < ActiveSupport::TestCase
  include Remets::PolicyAssertions

  test "#initialize raises when not authenticated" do
    assert_raises(ApplicationPolicy::NotAuthenticatedError) do
      DocumentPolicy.new(nil, nil)
    end
  end

  test "#index? is true when an admin" do
    assert_permit(users(:pierre), Document.all, :index)
  end

  test "#index? is false when a user" do
    refute_permit(users(:gaston), Document.all, :index)
  end

  test "#index? is false when not authenticated" do
    assert_permit_raises(nil, Document.all, :index, ApplicationPolicy::NotAuthenticatedError)
  end

  test "#show? is true when an admin" do
    assert_permit(users(:pierre), documents(:platypus), :show)
  end

  test "#show? is false when not authenticated" do
    assert_permit_raises(nil, documents(:platypus), :show, ApplicationPolicy::NotAuthenticatedError)
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

  test "#download? is false when not authenticated" do
    assert_permit_raises(nil, documents(:platypus), :download, ApplicationPolicy::NotAuthenticatedError)
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
