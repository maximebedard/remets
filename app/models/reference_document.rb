class ReferenceDocument < ApplicationRecord
  include HasFile

  belongs_to :evaluation
end
