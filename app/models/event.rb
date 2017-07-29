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

  scope :select_started, -> { scheduled.select("started_at") }
  scope :upcoming_event_year, -> { select_started.map{ |i| i.year }.uniq }
  scope :upcoming_event_month, -> (year){ select_started.map{ |i| i.month if i.year == year }.uniq }
  scope :upcoming_event_day, -> (month){ select_started.map{ |i| i.day if i.month == month }.uniq }
  scope :event_of_the_day, -> (year, month, day){ where(started_at: Time.new(year, month, day).all_day) }

  def self.upcoming_events
    events = []
    self.upcoming_event_year.each do |year|
      self.upcoming_event_month(year).each do |month|
        self.upcoming_event_day(month).each do |day|
          events << Event.event_of_the_day(year, month, day)
        end
      end
    end
    events
  end

  def year
    started_at.year
  end

  def month
    started_at.month
  rescue => e
    # TODO エラーの原因調査
    NotifyService.new.call(e, "Event.month (started_at:#{started_at})")
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
