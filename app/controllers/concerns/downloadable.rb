module Downloadable
  extend ActiveSupport::Concern

  included do
    class_attribute :downloadable_class
  end

  def download
    authorize(downloadable)

    send_file(
      downloadable.file_ptr.current_path,
      disposition: :inline,
    )
  end

  private

  def downloadable
    @document ||= policy_scope(
      self.class.downloadable_class.where(id: params[:id]),
    ).first!
  end
end
