class DocumentFingerprintingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)

    fingerprint(document)
    index(document)
  end

  def fingerprint(document)
    service = Winnowing.new
    document.update(windows: service.winnow(document.sanitized_content))
  end

  def index(document)
    DocumentIndexingWorker.perform_async(document.id)
  end
end
