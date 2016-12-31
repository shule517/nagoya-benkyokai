#encoding: utf-8
class Event < ApplicationRecord
  has_many :participants
  has_many :users, through: :participants

  def year
    started_at[0...4].to_i
  end

  def month
    started_at[5...7].to_i
  end

  def day
    started_at[8...10].to_i
  end

  def wday
    d = Date.new(year, month, day)
    %w(日 月 火 水 木 金 土)[d.wday]
  end
end
