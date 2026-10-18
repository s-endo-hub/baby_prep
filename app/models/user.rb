class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :preparation_items, dependent: :destroy

  validates :name, presence: true
  validates :due_date, presence: true

  after_create :create_default_preparation_items

  DEFAULT_PREPARATION_ITEMS = [
    { name: "おむつ", category: :baby },
    { name: "おしりふき", category: :baby },
    { name: "ベビー服", category: :baby },
    { name: "肌着", category: :baby },
    { name: "ガーゼ", category: :baby },
    { name: "哺乳瓶", category: :baby },
    { name: "粉ミルク", category: :baby },
    { name: "ベビーバス", category: :baby },
    { name: "ベビー布団", category: :baby },
    { name: "体温計", category: :baby },
    { name: "授乳ブラ", category: :mother },
    { name: "産褥ショーツ", category: :mother },
    { name: "母乳パッド", category: :mother },
    { name: "マタニティパジャマ", category: :mother },
    { name: "産褥パッド", category: :mother },
    { name: "入院用バッグ", category: :mother },
    { name: "洗面用具", category: :mother },
    { name: "スリッパ", category: :mother },
    { name: "タオル", category: :mother },
    { name: "飲み物用ストロー", category: :mother }
  ].freeze

  def reset_preparation_items!
    preparation_items.destroy_all
    create_default_preparation_items
  end

  private

  def create_default_preparation_items
    DEFAULT_PREPARATION_ITEMS.each do |item|
      preparation_items.create!(item)
    end
  end
end
