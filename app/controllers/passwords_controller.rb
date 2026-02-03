class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_employee_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: t("password.try_again_later") }

  def new
  end

  def create
    if employee = Employee.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(employee).deliver_later
    end

    redirect_to new_session_path, notice: t("password.reset_sent")
  end

  def edit
  end

  def update
    if @employee.update(params.permit(:password, :password_confirmation))
      @employee.sessions.destroy_all
      redirect_to new_session_path, notice: t("password.password_reset")
    else
      redirect_to edit_password_path(params[:token]), alert: t("password.passwords_did_not_match")
    end
  end

  private
    def set_employee_by_token
      @employee = Employee.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: t("password.link_invalid")
    end
end
