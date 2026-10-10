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

  validates :name, presence: true
end
