class Document < ActiveRecord::Base
  validates :signature, presence: true
  validates :text, presence: true
  validates :url, presence: true
end
