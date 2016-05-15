class GradedDocument < ActiveRecord::Base
  include DirectUploadable

  belongs_to :grade
end
