class Handover < ActiveRecord::Base
  has_many :documents, as: :documentable
  has_many :submissions
  belongs_to :user

  alias_method :boilerplate_documents, :documents

  accepts_nested_attributes_for :documents
end
