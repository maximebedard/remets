class Handover < ActiveRecord::Base
  has_many :boilerplate_documents,
    as: :documentable,
    class_name: Document
  has_many :submissions
  belongs_to :user
end
