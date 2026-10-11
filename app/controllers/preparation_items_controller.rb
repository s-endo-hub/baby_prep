class PreparationItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @preparation_items = current_user.preparation_items
  end

  def update
    @preparation_item = current_user.preparation_items.find(params[:id])
    status = params[:status]

    unless %w[ready unprepared].include?(status)
      redirect_to root_path, alert: "無効な準備状況です。"
      return
    end

    if @preparation_item.update(status: status)
      redirect_to root_path, notice: "準備状況を変更しました！"
    else
      redirect_to root_path, alert: "準備状況を変更できませんでした。"
    end
  end
end
