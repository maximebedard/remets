class Handover < ActiveRecord::Base
  has_many :submissions

  belongs_to :user
end
