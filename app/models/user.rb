class User < ApplicationRecord
  has_many :participants
  has_many :events, through: :participants
end
