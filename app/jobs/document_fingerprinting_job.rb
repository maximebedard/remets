class DocumentFingerprintingJob < ApplicationJob
  queue_as :default

  def perform(document)
    windows = document.generate_windows
    return if windows.empty?

    update(document, windows)
  end

  private

  def update(document, windows)
    document.update!(
      windows: windows,
      fingerprinted_at: Time.zone.now,
    )
  end
end
