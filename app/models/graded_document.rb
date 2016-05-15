class GradedDocument < ActiveRecord::Base
  include HasFile

  belongs_to :grade
end
