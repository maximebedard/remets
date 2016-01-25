class Handover < ActiveRecord::Base
  has_many :reference_documents
  has_many :boilerplate_documents
  has_many :submissions

  belongs_to :user

  accepts_nested_attributes_for :boilerplate_documents,
    :reference_documents

  def fingerprintable_documents
    boilerplate_documents
  end
end
