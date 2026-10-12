class PreparationItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @preparation_items = current_user.preparation_items
    @unprepared_items = current_user.preparation_items.unprepared
 
    @total_items = @preparation_items.count
    @ready_items_count = @preparation_items.ready.count

    @progress_rate =
      if @total_items.zero?
        0
      else
        (@ready_items_count.to_f / @total_items * 100).round
      end

    @days_until_due = (current_user.due_date - Date.current).to_i
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

  def create
    @preparation_item = current_user.preparation_items.new(preparation_item_params)

    if @preparation_item.save
      redirect_to root_path, notice: "準備アイテムを追加しました！"
    else
      redirect_to root_path, alert: "準備アイテムを追加できませんでした。"
    end
  end

  def destroy
    @preparation_item = current_user.preparation_items.find(params[:id])
    @preparation_item.destroy

    redirect_to root_path, notice: "準備アイテムを削除しました！"
  end

  private

  def preparation_item_params
    params.require(:preparation_item).permit(:name, :category)
  end
end
