require "test_helper"

class DocumentFingerprintingJobTest < ActiveSupport::TestCase
  setup do
    @document = documents(:platypus)
  end

  test "#perform does not update the document when there is no windows" do
    Winnower.stubs(:windows_from_content).returns(Set.new)
    DocumentFingerprintingJob.perform_now(@document.id)

    @document.reload
    assert_nil @document.fingerprinted_at
    assert_empty @document.windows
  end

  test "#perform does not queue an indexing job when there is no windows" do
    Winnower.stubs(:windows_from_content).returns(Set.new)
    assert_no_enqueued_jobs do
      DocumentFingerprintingJob.perform_now(@document.id)
    end
  end

  test "#perform updates the document with the windows" do
    Winnower.stubs(:windows_from_content).returns(Set.new([[0, 1234]]))
    travel(1.day) do
      DocumentFingerprintingJob.perform_now(@document.id)

      @document.reload
      assert_equal Time.zone.now, @document.fingerprinted_at
      assert_equal [[0, 1234]], @document.windows
    end
  end

  test "#perform queue an indexing job" do
    Winnower.stubs(:windows_from_content).returns(Set.new([[0, 1234]]))
    assert_enqueued_with(job: DocumentIndexingJob, args: [@document.id], queue: "default") do
      DocumentFingerprintingJob.perform_now(@document.id)
    end
  end
end
