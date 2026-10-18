require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "ユーザー作成時に初期アイテムが20件作成される" do
    user = User.create!(
      name: "テストユーザー",
      email: "new_user@example.com",
      password: "password123",
      due_date: Date.current + 60.days
    )

    assert_equal 20, user.preparation_items.count
  end

  test "初期アイテムが赤ちゃん用とママ用に10件ずつ作成される" do
    user = User.create!(
      name: "テストユーザー",
      email: "new_user2@example.com",
      password: "password123",
      due_date: Date.current + 60.days
    )

    assert_equal 10, user.preparation_items.baby.count
    assert_equal 10, user.preparation_items.mother.count
  end
end
