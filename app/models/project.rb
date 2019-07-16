class Project < ApplicationRecord
  has_many :project_users
  has_many :users, through: :project_users
  accepts_nested_attributes_for :project_users
  validates :name, presence: true
  validates_date :due_on, on_or_after: lambda { Date.current }, allow_blank: true
end
