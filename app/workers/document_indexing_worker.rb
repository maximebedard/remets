class DocumentIndexingWorker
  include Sidekiq::Worker

  def perform(document_id)
    reference = Document.find(document_id)

    Document.all_fingerprinted_except(reference).find_each do |compared|
      matching_fingerprints = reference.fingerprints & compared.fingerprints

      DocumentMatch.create!(
        reference_document: reference,
        compared_document: compared,
        matching_fingerprints: matching_fingerprints
      )
    end
  end
end

