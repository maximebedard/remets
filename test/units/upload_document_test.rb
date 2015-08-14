require 'test_helper'

class UploadDocumentTest < ActiveSupport::TestCase
  setup do
    @fixture = fixture_file_upload('files/text_document.txt')
    @service = UploadDocument.new(@fixture)
  end

  test '#call saves the uploaded file on disk' do
    @service.call
  end

  test '#call create a new document record' do
    SecureRandom.stubs(:hex).with(10).returns('c5cc864c0df4ff68cd49')

    assert_difference "Document.count" do
      @service.call
    end
    document = Document.last
    assert document.url.end_with?('public/uploads/c5cc864c0df4ff68cd49-text_document.txt')
  end
end
