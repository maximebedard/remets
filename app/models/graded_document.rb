class GradedDocument < ActiveRecord::Base
  mount_uploader :file_ptr, FileUploader
  delegate :file, to: :file_ptr

  belongs_to :grade
end