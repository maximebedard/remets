require "test_helper"

class HandoverUpdaterTest < ActiveSupport::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    @handover = Handover.new
    @service = HandoverUpdater.new(
      @handover,
      users(:henry),
      title: "pants",
      description: "pants pants pants",
      due_date: 5.days.from_now,
      organization: organizations(:ets).id,
      subscriptions: ["idont@exists.com"],
      reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
      boilerplate_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
    )
  end

  test "#call build the subscriptions" do
    assert_difference("Subscription.count") do
      @service.call
    end

    assert_equal "idont@exists.com",
      @handover.subscriptions.first.user.email
  end

  test "#call build the organization association" do
    @service.call
    assert_equal organizations(:ets), @handover.organization
  end

  test "#call queues the fingerprinting job" do
    assert_enqueued_with(job: DocumentFingerprintingJob, queue: "default") do
      @service.call
    end
  end
end
