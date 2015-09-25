class ComparedDocument < ActiveRecord::Base
  belongs_to :document1, class: 'Document'
  belongs_to :document2, class: 'Document'

  validates :document1, :document2, presence: true
end
