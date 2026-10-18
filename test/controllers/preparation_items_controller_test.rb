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

  test "アイテム名が空だと追加できない" do
    sign_in users(:one)

    assert_no_difference("PreparationItem.count") do
      post preparation_items_url, params: {
        preparation_item: {
          name: "",
          category: "baby"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "アイテム名が50文字を超えると追加できない" do
    sign_in users(:one)

    assert_no_difference("PreparationItem.count") do
      post preparation_items_url, params: {
        preparation_item: {
          name: "あ" * 51,
          category: "baby"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "不正な準備状況では更新できない" do
    sign_in users(:one)

    item = preparation_items(:one)

    patch preparation_item_url(item), params: { status: "invalid" }

    assert_redirected_to root_path
    assert_equal "unprepared", item.reload.status
  end

  test "ダッシュボードに出産準備リストが表示される" do
    sign_in users(:one)

    get root_path

    assert_response :success
    assert_select "h1", "出産準備リスト"
    assert_select "h2", "出産予定日まで"
    assert_select "h2", "準備の進捗"
    assert_select "h2", "これから準備するもの"
  end
  
  test "ダッシュボードに準備の進捗率が表示される" do
    user = users(:one)
    sign_in user

    user.preparation_items.update_all(status: "not_ready")
    user.preparation_items.first.update!(status: "ready")
    user.preparation_items.create!(
      name: "テスト用の肌着",
      category: "baby",
      status: "not_ready"
    )

    get root_path

    assert_response :success
    assert_select ".progress-card .dashboard-number", "50%"
    assert_select ".progress-card p", "1 / 2 件準備OK"
  end

  test "これから準備するアイテムがダッシュボードに表示される" do
    user = users(:one)
    sign_in user

    user.preparation_items.update_all(status: "not_ready")

    get root_path

    assert_response :success
    assert_select ".unprepared-section", /これから準備するもの/
    assert_select ".unprepared-section", /テスト用のおむつ/
    assert_select ".unprepared-count", "未準備 1 件"
  end

  test "ダッシュボードに出産予定日までの日数が表示される" do
    user = users(:one)
    sign_in user

    user.update!(due_date: Date.current + 30.days)

    get root_path

    assert_response :success
    assert_select ".due-date-card .dashboard-number", "あと 30 日"
  end
end
