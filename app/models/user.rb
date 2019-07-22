class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  def send_devise_notification(notification, *args_for_invitation_instructions)
    project_user = self.project_users.find_by(has_sent_message: false)

    # devise_invite_mailerにプロジェクトidを渡す引数の設定
    args_for_invitation_instructions[1][:invited_project_id] = project_user.project_id
    devise_mailer.send(notification, self, *args_for_invitation_instructions).deliver
    project_user.update(has_sent_message: true)
  end

private

end
