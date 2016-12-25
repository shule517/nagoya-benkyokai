class User < ApplicationRecord
  has_many :event_users
  has_many :events, through: :event_users
end
