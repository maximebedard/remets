class Submission < ActiveRecord::Base
  has_many :documents

  belongs_to :handover
  belongs_to :user

  accepts_nested_attributes_for :documents

  def fingerprintable_documents
    documents
  end
end
