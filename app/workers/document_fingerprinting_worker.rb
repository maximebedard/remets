class DocumentFingerprintingWorker
  include Sidekiq::Worker

  def perform(document_id)
    # document = Document.find(document_id)

    # fingerprint(document)
    # index(document)
  end

  def fingerprint(document)
    windows = Winnower.windows_from_content(document.sanitized_content)
    document.update!(windows: windows)
  end

  def index(document)
    DocumentIndexingWorker.perform_async(document.id)
  end
end
