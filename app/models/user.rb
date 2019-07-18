class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
