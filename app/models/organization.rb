class Organization < ActiveRecord::Base
  has_many :users, through: :user_organizations

  belongs_to :user

  validates :name, :user, presence: true
end
