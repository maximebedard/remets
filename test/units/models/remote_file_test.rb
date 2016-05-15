require "test_helper"

class RemoteFileTest < ActiveSupport::TestCase
  setup do
    @key = submitted_documents(:platypus).file_ptr
    @file = RemoteFile.new(@key)
  end

  test "#exists?" do
    stub_s3(@key)
    assert_equal true, @file.exists?
  end

  test "#exists? on a file that does not exists on s3" do
    stub_s3(@key, status: 404)
    assert_equal false, @file.exists?
  end

  test "#content" do
    stub_s3(@key, method: :get, body: "pants")
    assert_equal "pants", @file.content
  end

  test "#content on a file that does not exists on s3" do
    stub_s3(@key, method: :get, status: 404)
    assert_nil @file.content
  end

  test "#url" do
    stub_s3(@key, method: :get, body: "pants")
    assert_match %r{https:\/\/.*#{@key}}, @file.url
  end

  test "#url on a file that does not exists on s3" do
    stub_s3(@key, method: :get, status: 404)
    assert_match %r{https:\/\/.*#{@key}}, @file.url
  end

  private

  def stub_s3(key, method: :head, status: 200, body: "")
    stub_request(method, "#{Bucket.url}/#{key}")
      .to_return(status: status, body: body, headers: {})
  end
end
