class Event < ApplicationRecord
  has_many :participants, dependent: :delete_all
  has_many :participant_users, through: :participants, source: :user

  has_many :owners_participant, -> { where(owner: true) }, class_name: 'Participant'
  has_many :owners, -> { order(twitter_id: :desc) }, through: :owners_participant, source: :user

  has_many :users_participant, -> { where(owner: false) }, class_name: 'Participant'
  has_many :users, -> { order(twitter_id: :desc) }, through: :users_participant, source: :user

  has_many :event_tags, dependent: :delete_all
  has_many :tags, through: :event_tags, source: :tag

  scope :scheduled, -> { where('started_at >= ?', Date.today).order(:started_at) }
  scope :ended, -> { where('started_at < ?', Date.today).order(started_at: :desc) }

  def self.upcoming_events
    group('date(started_at)').select('date(started_at) as date').map do |event|
      where(started_at: Time.parse(event.date.strftime).all_day)
    end
  end

  def twitter_list_url_gsub
    Rails.env.development? ? url = 'benkyo_dev' : url = 'nagoya_lambda'
    twitter_list_url.gsub("#{url}", "#{url}/lists")
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
