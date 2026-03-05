class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true, if: -> { role == "user" }
  validates :role, inclusion: { in: %w[user assistant] }
end
