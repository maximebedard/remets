class Grade < ActiveRecord::Base
  has_many :graded_documents

  belongs_to :submission

  accepts_nested_attributes_for :graded_documents
end
