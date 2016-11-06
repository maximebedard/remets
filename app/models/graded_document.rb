class GradedDocument < ApplicationRecord
  include HasFile

  belongs_to :grade
end
