require "test_helper"

class EvaluationUpdaterTest < ActiveSupport::TestCase
  setup do
    @evaluation = Evaluation.new(user: users(:henry))
    @service = EvaluationUpdater.new(
      @evaluation,
      title: "pants",
      description: "pants pants pants",
      due_date: 5.days.from_now,
      organization: organizations(:ets).id,
      subscriptions: ["idont@exists.com"],
      reference_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
      boilerplate_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    )
  end

  test "#call build the subscriptions" do
    assert_difference("Subscription.count") do
      @service.call
    end

    assert_equal "idont@exists.com",
      @evaluation.subscriptions.first.user.email
  end

  test "#call build the organization association" do
    @service.call
    assert_equal organizations(:ets), @evaluation.organization
  end

  test "#call queues the sanitization job" do
    assert_enqueued_with(job: DocumentSanitizationJob, queue: "default") do
      @service.call
    end
  end
end
