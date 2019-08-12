class Users::UsersController < ApplicationController
  before_action :admin_user, only: %i[destroy]
  PER = 10

  def index
    @users = User.page(params[:page]).per(PER)
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
