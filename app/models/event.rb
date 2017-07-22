class Event < ApplicationRecord
  has_many :participants, dependent: :delete_all
  has_many :participant_users, through: :participants, source: :user

  has_many :owners_participant, -> { where(owner: true) }, class_name: 'Participant'
  has_many :owners, -> { order('twitter_id DESC') }, through: :owners_participant, source: :user

  has_many :users_participant, -> { where(owner: false) }, class_name: 'Participant'
  has_many :users, -> { order('twitter_id DESC') }, through: :users_participant, source: :user

  has_many :event_tags, dependent: :delete_all
  has_many :tags, through: :event_tags, source: :tag

  scope :scheduled, -> { where('started_at >= ?', Date.today).order(:started_at) }
  scope :ended, -> { where('started_at < ?', Date.today).order(started_at: :desc) }

  def year
    started_at.year
  end

  def month
    started_at.month
  rescue => e
    p e
  end

  def day
    started_at.day
  end

  def wday
    d = Date.new(year, month, day)
    %w(日 月 火 水 木 金 土)[d.wday]
  end
end
