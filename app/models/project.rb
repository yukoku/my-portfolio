class Project < ApplicationRecord
  has_many :project_users
  has_many :users, through: :project_users
  accepts_nested_attributes_for :project_users
  validates :name, presence: true
end
