module Downloadable
  extend ActiveSupport::Concern

  def download
    authorize(downloadable)

    send_file(
      downloadable.file_ptr.current_path,
      disposition: :inline,
    )
  end

  module ClassMethods
    def downloadable_class
      to_s.gsub(/sController/, "").constantize
    end
  end

  private

  def downloadable
    @downloadable ||= policy_scope(
      self.class.downloadable_class.where(id: params[:id]),
    ).first!
  end
end
