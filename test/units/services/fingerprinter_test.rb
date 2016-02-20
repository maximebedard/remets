require "test_helper"

module FingerprinterTests
  extend ActiveSupport::Concern

  included do
    test "#call creates a #{@subject.class} with a single document" do
      assert_difference(["#{@subject.class}.count", "#{fingerprintable_klass}.count"]) do
        call(files: [sanitizable_file_upload])
      end
    end

    test "#call fingerprints a single document content" do
      assert_enqueued_jobs(1) do
        call(files: [sanitizable_file_upload])
      end
    end

    test "#call creates a #{@subject.class} with multiple documents" do
      assert_difference("#{@subject.class}.count") do
        assert_difference("#{fingerprintable_klass}.count", 2) do
          call(files: [sanitizable_file_upload] * 2)
        end
      end
    end

    test "#call fingerprints multiple documents content" do
      assert_enqueued_jobs(2) do
        call(files: [sanitizable_file_upload] * 2)
      end
    end

    test "#call does not fingerprints when the #{@subject.class} is invalid" do
      @subject.stubs(:valid?).returns(false)
      assert_no_enqueued_jobs do
        call(files: [sanitizable_file_upload])
      end
    end
  end
end

class SubmissionFingerprinterTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper
  include FingerprinterTests

  setup do
    @subject = Submission.new
  end

  private

  def call(files: [])
    Fingerprinter.new(
      @subject,
      documents_attributes: files.map { |f| { file_ptr: f } },
    ).call
  end

  def fingerprintable_klass
    Document
  end
end

class HandoverFingerprinterTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper
  include FingerprinterTests

  setup do
    @subject = Handover.new
  end

  def call(files: [])
    Fingerprinter.new(
      @subject,
      boilerplate_documents_attributes: files.map { |f| { file_ptr: f } },
      due_date: 5.days.from_now,
    ).call
  end

  def fingerprintable_klass
    BoilerplateDocument
  end
end
