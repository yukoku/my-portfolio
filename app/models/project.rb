class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  accepts_nested_attributes_for :project_users
  validates :name, presence: true, uniqueness: { scope: :owner_id }
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
end
