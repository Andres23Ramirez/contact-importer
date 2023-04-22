# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  private

  def record_not_unique
    flash[:error] = "Username has already been taken."
    redirect_to new_user_registration_path
  end
  
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
