class DocumentIndexingJob < ActiveJob::Base
  queue_as :default

  def perform(document_id)
    reference = Document.find(document_id)

    Document.all_fingerprinted_except(reference).find_each do |compared|
      matching_fingerprints = reference.fingerprints & compared.fingerprints
      next if matching_fingerprints.blank?

      DocumentMatch.create!(
        reference_document: reference,
        compared_document: compared,
        fingerprints: matching_fingerprints,
      )
    end
  end
end
