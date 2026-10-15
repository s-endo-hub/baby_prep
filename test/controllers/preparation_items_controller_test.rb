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

  test "自分の準備アイテムを追加できる" do
    sign_in users(:one)

    assert_difference("PreparationItem.count", 1) do
      post preparation_items_url, params: {
        preparation_item: {
          name: "ベビー用爪切り",
          category: "baby"
        }
      }
    end

    assert_redirected_to root_path
    assert_equal "ベビー用爪切り", users(:one).preparation_items.last.name
  end
  
  test "自分の準備アイテムを削除できる" do
    sign_in users(:one)

    item = preparation_items(:one)

    assert_difference("PreparationItem.count", -1) do
      delete preparation_item_url(item)
    end

    assert_redirected_to root_path
  end
end
