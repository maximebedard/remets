class DocumentIndexingJob < ActiveJob::Base
  queue_as :default

  def perform(document_id)
    reference = Document.find(document_id)

    Document.all_fingerprinted_except(reference).find_each do |compared|
      DocumentMatch.create_from!(reference, compared)
    end
  end
end
