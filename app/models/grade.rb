class Grade < ApplicationRecord
  has_many :graded_documents

  belongs_to :submission

  accepts_nested_attributes_for :graded_documents

  validates(
    :result,
    :comments,
    presence: true,
  )

  validates(
    :result,
    inclusion: 0..100,
  )
end
