class ReferenceDocument < ActiveRecord::Base
  include HasFile

  belongs_to :evaluation
end
