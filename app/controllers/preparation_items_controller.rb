class PreparationItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @preparation_items = current_user.preparation_items
  end

  def update
    @preparation_item = current_user.preparation_items.find(params[:id])

    if @preparation_item.update(status: :ready)
      redirect_to root_path, notice: "準備OKにしました！"
    else
      redirect_to root_path, alert: "準備状況を変更できませんでした。"
    end
  end
end
