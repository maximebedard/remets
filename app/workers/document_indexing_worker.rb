class DocumentIndexingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)

    Document.all_except(document).find_in_batches do |compared|
      matching_fingerprints = document.fingerprints & compared.fingerprints

      DocumentMatch.create!(
        reference_document: document,
        compared_document: compared,
        matching_fingerprints: matching_fingerprints
      )
    end
  end
end
