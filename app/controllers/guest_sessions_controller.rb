class GuestSessionsController < ApplicationController
  def create
    guest_user = User.find_or_initialize_by(email: "guest@example.com")

    if guest_user.new_record?
      guest_user.name = "ゲストユーザー"
      guest_user.due_date = 30.days.from_now.to_date
      guest_user.password = SecureRandom.hex(10)
      guest_user.save!
    else
      guest_user.update!(due_date: 30.days.from_now.to_date)
      guest_user.reset_preparation_items!
    end

    sign_in(guest_user)
    redirect_to root_path, notice: "ゲストとしてログインしました！"
  end
end