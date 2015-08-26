class Submission < ActiveRecord::Base
  has_many :documents

  accepts_nested_attributes_for :documents
end
