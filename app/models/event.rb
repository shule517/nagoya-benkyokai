# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  title             :string
#  catch             :string
#  description       :string
#  event_url         :string
#  url               :string
#  address           :string
#  place             :string
#  updated_at        :datetime         not null
#  hash_tag          :string
#  place_enc         :string
#  source            :string
#  group_url         :string
#  group_title       :string
#  group_logo_url    :string
#  logo_url          :string
#  created_at        :datetime         not null
#  tweeted_new       :boolean          default(FALSE), not null
#  tweeted_tomorrow  :boolean          default(FALSE), not null
#  twitter_list_name :string
#  twitter_list_url  :string
#  event_id          :integer
#  limit             :integer
#  accepted          :integer
#  waiting           :integer
#  group_id          :integer
#  started_at        :datetime
#  ended_at          :datetime
#  update_time       :datetime
#  lat               :decimal(17, 14)
#  lon               :decimal(17, 14)
#
# Indexes
#
#  index_events_on_event_url   (event_url)
#  index_events_on_started_at  (started_at)
#  index_events_on_twitter_id  ()
#

class Event < ApplicationRecord
  has_many :participants, dependent: :delete_all
  has_many :participant_users, through: :participants, source: :user

  has_many :owners_participant, -> { where(owner: true) }, class_name: 'Participant'
  has_many :owners, -> { order('twitter_id DESC') }, through: :owners_participant, source: :user

  has_many :users_participant, -> { where(owner: false) }, class_name: 'Participant'
  has_many :users, -> { order('twitter_id DESC') }, through: :users_participant, source: :user

  has_many :event_tags, dependent: :delete_all
  has_many :tags, through: :event_tags, source: :tag

  scope :scheduled, -> { where('started_at >= ?', Date.today).order(:started_at).includes(:users, :owners) }
  scope :ended, -> { where('started_at < ?', Date.today).order(started_at: :desc).includes(:users, :owners) }

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

  def twitter_list_url
    url = read_attribute(:twitter_list_url)
    url.gsub(%r((https://twitter.com/[a-z0-9_]+/)), '\1lists/') if url.present?
  end

  def twitter_list_url_raw
    read_attribute(:twitter_list_url)
  end
end
