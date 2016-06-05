class DocumentFingerprintingJob < ActiveJob::Base
  queue_as :default

  def perform(document)
    windows = document.generate_windows

    return unless windows.present?

    update(document, windows)
  end

  def update(document, windows)
    document.update!(
      windows: windows,
      fingerprinted_at: Time.zone.now,
    )
  end
end
