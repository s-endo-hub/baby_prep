require "test_helper"

class PreparationItemsControllerTest < ActionDispatch::IntegrationTest
  test "他のユーザーの準備アイテムを更新できない" do
    sign_in users(:one)

    item = preparation_items(:two)

    patch preparation_item_url(item), params: { status: "ready" }

    puts "レスポンスステータス: #{response.status}"
    puts "更新対象の準備状況: #{item.reload.status}"

    assert_not_equal "ready", item.reload.status
  end


  test "他のユーザーの準備アイテムを削除できない" do
    sign_in users(:one)

    item = preparation_items(:two)

    assert_no_difference("PreparationItem.count") do
      delete preparation_item_url(item)
    end

    assert_response :not_found
  end
end
