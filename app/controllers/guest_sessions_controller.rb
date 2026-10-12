class GuestSessionsController < ApplicationController
  def create
    guest_user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲストユーザー"
      user.due_date = 30.days.from_now.to_date
      user.password = SecureRandom.hex(10)
    end

    sign_in(guest_user)
    redirect_to root_path, notice: "ゲストとしてログインしました！"
  end
end