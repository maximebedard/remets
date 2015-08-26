require 'test_helper'

class SubmissionCreationServiceTest < ActiveSupport::TestCase
  setup do
    @fixture = fixture_file_upload('files/documents/file/605975481/text_document1.txt')
    @service = SubmissionCreationService.new({
      documents_attributes: [
        { file: @fixture }
      ]
    })
  end

  test '#call creates a new submission' do
    assert_difference ["Submission.count", "Document.count"] do
      @service.call
    end
  end

  test '#call add shingles to the sumbission' do
    submission = @service.call
    assert_equal \
      [254149830, 156990633, 49670451, 124562433].sort,
      submission.documents.first.shingles.sort
  end
end
