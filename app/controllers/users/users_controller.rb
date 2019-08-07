class Users::UsersController < ApplicationController
  before_action :admin_user, only: %i[destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t('user.crud.flash.deleted')
    redirect_to users_url
  end

private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
