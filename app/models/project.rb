class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members
  accepts_nested_attributes_for :project_members
  validates :name, presence: true, uniqueness: { scope: :owner_id }
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
end
