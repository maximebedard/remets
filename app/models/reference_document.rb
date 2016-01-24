class ReferenceDocument < ActiveRecord::Base
  mount_uploader :file_ptr, FileUploader

  belongs_to :handover
end
