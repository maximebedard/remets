class Document < ActiveRecord::Base
  validates :content, presence: true
  validates :url, presence: true
end
