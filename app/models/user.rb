class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "assignee_id"
  has_many :created_tickets, class_name: "Ticket", foreign_key: "creator_id"
  has_many :comments, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  before_destroy :update_tickets_items_to_nil

private

  def update_tickets_items_to_nil
    Ticket.where("creator_id = ?", self.id).update_all(creator_id: nil)
    Ticket.where("assignee_id = ?", self.id).update_all(assignee_id: nil)
  end
end
