class DocumentFingerprintingJob < ActiveJob::Base
  queue_as :default

  def perform(document)
    windows = Winnower.windows_from_content(document.sanitized_content).to_a

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
