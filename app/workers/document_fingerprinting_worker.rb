class DocumentFingerprintingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)

    fingerprint(document)
    index(document)
  end

  def fingerprint(document)
    service = Winnowing.new
    windows = service.winnow(document.sanitized_content)
    document.update(windows: windows)
  end

  def index(document)
    DocumentIndexingWorker.perform_async(document.id)
  end
end
