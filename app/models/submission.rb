class Submission < ActiveRecord::Base
  has_many :documents, as: :documentable

  belongs_to :handover
  belongs_to :user

  accepts_nested_attributes_for :documents
end
