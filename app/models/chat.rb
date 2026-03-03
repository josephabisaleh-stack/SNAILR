class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  has_many :messages, dependent: :destroy
end
