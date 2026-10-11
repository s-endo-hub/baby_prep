class PreparationItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @preparation_items = current_user.preparation_items
  end
end
