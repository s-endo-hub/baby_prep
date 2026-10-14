require "test_helper"

class PreparationItemsControllerTest < ActionDispatch::IntegrationTest
  test "他のユーザーの準備アイテムを更新できない" do
    sign_in users(:one)

    item = preparation_items(:two)

    patch preparation_item_url(item), params: { status: "ready" }

    assert_response :not_found
    assert_equal "unprepared", item.reload.status
  end

  test "他のユーザーの準備アイテムを削除できない" do
    sign_in users(:one)

    item = preparation_items(:two)

    assert_no_difference("PreparationItem.count") do
      delete preparation_item_url(item)
    end

    assert_response :not_found
  end

  test "自分の準備アイテムを更新できる" do
    sign_in users(:one)

    item = preparation_items(:one)

    patch preparation_item_url(item), params: { status: "ready" }

    assert_redirected_to root_path(
      anchor: "preparation-checklist",
      category: item.category
    )
    assert_equal "ready", item.reload.status
  end
end
