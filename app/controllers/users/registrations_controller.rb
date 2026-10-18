class Users::RegistrationsController < Devise::RegistrationsController
  before_action :prevent_guest_account_changes, only: [:edit, :update, :destroy]

  private

  def prevent_guest_account_changes
    return unless current_user&.email == "guest@example.com"

    redirect_to root_path, alert: "ゲストユーザーはプロフィールを変更できません。"
  end
end
