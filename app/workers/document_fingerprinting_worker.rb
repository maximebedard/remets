class DocumentIndexingWorker
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)

    windows = Winnowing.new.call(document.content)
    document.update!(windows: windows)
  end
end
