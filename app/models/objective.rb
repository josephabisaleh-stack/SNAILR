class Objective < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_one :chat, dependent: :destroy

  enum :status, {
    in_creation: "in_creation",
    in_progress: "in_progress",
    completed: "completed"
  }

  validates :progress, numericality: { in: 0..100 }
end
