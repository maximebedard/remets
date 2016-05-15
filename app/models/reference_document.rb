class ReferenceDocument < ActiveRecord::Base
  include DirectUploadable

  belongs_to :evaluation
end
