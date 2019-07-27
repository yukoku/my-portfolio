class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :invitable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

protected
  def send_devise_notification(notification, *args)
    return super(notification, *args) unless notification == :invitation_instructions

    # ToDo:メッセージ送ってないを条件に探すのは良くないので改善する
    project_user = self.project_users.find_by(has_sent_message: false)

    # devise_invite_mailerにプロジェクトidを渡す引数の設定
    args[1][:invited_project_id] = project_user.project_id
    devise_mailer.send(notification, self, *args).deliver
    project_user.update(has_sent_message: true)
  end

private

end
