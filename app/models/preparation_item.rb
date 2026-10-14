class PreparationItem < ApplicationRecord
  belongs_to :user

  enum :category, {
    baby: "baby",
    mother: "mother"
  }

  enum :status, {
    ready: "ready",
    unprepared: "not_ready"
  }

  validates :name, presence: true, length: { maximum: 50 }
  validates :category, presence: true
end
