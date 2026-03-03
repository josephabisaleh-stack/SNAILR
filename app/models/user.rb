class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :objectives, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :display_name, presence: true
  validates :total_xp, numericality: { greater_than_or_equal_to: 0 }
end
