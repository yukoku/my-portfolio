class Project < ApplicationRecord
  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members
  has_many :tickets, dependent: :destroy
  has_many :ticket_attributes, dependent: :destroy
  has_many :ticket_priorities, dependent: :destroy
  has_many :ticket_statuses, dependent: :destroy
  has_many :ticket_metadata, dependent: :destroy, class_name: "TicketMetadata"
  accepts_nested_attributes_for :project_members
  validates :name, presence: true, length: { maximum: 25 }
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true

  after_create :create_default_data_related_to_ticket

private

  def create_default_data_related_to_ticket
    TicketMetadata.default_setting(self.id)
  end
end
