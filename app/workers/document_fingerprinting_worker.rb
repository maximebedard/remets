class DocumentFingerprintingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)
    windows = Winnower.windows_from_content(document.sanitized_content).to_a
    binding.pry
    return unless windows.present?

    update(document, windows)
    index(document)
  end

  def update(document, windows)
    document.update!(
      windows: windows,
      fingerprinted_at: Time.zone.now
    )
  end

  def index(document)
    DocumentIndexingWorker.perform_async(document.id)
  end
end
