class DocumentIndexingJob < ActiveJob::Base
  queue_as :default

  def perform(reference)
    reference.document_matches.destroy_all

    SubmittedDocument.all_fingerprinted_except(reference).find_each do |compared|
      DocumentMatch.create_from!(reference, compared)
    end
  end
end
