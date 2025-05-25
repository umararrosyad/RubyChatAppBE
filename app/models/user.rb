class User < ApplicationRecord
  has_many :room_users
  has_many :rooms, through: :room_users

  validates :nickname, presence: true, uniqueness: true
end