require 'test_helper'

class UploadDocumentTest < ActiveSupport::TestCase
  setup do
    @fixture = File.open(Rails.root.join('test', 'fixtures', 'document.txt'), 'r')
    @fixture.stubs(original_filename: 'document.txt')
    @service = UploadDocument.new
  end

  test '#call saves the uploaded file on disk' do
  end

  test '#call create a new document record' do
  end
end
