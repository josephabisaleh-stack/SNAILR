class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true, if: -> { role == "user" }
  validates :role, inclusion: { in: %w[user assistant] }

  after_create_commit -> {
    broadcast_append_to chat, target: "messages", partial: "messages/message", locals: { message: self }
  }
end
