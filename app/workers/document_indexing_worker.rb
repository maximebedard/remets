class DocumentIndexingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)

    Document.where.not(id: document_id).find_in_batches do |compared|
      common_fingerprints = document.fingerprints & compared.fingerprints
    end
  end
end
