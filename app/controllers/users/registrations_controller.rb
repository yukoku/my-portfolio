# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :test_user, only: %i[update destroy]

private
  def test_user
    if current_user.name == "test_user"
      flash[:danger] = I18n.t("user.crud.flash.forbidden_change_profile_for_test_user")
      redirect_to root_url
    end
  end
end
