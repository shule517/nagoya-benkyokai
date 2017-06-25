class EventsController < ApplicationController
  def index
    today = Time.now.strftime('%Y-%m-%d')
    @events = Event.all.where(['started_at > ?', today]).order(:started_at)
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end

  def group
    groups = Event.group(:group_id).count.sort_by { |k, v| v }.reverse.select { |v| v[0].present? }
    p groups
    # ng = ["2546", "2532", "2462", "7403"]
    # groups = groups.select{|group| !ng.include?(group[0])}
    @events = []
    groups.each do |group|
      @events += Event.where(group_id: group[0]).order(:started_at)
    end
  end

  def place
    groups = Event.group(:place).count.sort_by { |k, v| v }.reverse.select { |v| v[0].present? }
    p groups
    @events = []
    groups.each do |group|
      @events += Event.where(place: group[0]).order(:started_at)
    end
  end

  def owner
    owners = Participant.where(owner: true).group(:user_id).count.sort_by { |k, v| v }.reverse
    @events = []
    owners.each do |owner|
      @events += Participant.where(user_id: owner[0], owner: true).order(:event_id).map { |v| [User.find(owner[0]), v.event] }
    end
  end

  def user
    users = Participant.where(owner: false).group(:user_id).count.sort_by { |k, v| v }.reverse
    @events = []
    users.each do |user|
      @events += Participant.where(user_id: user[0], owner: false).order(:event_id).map { |v| [User.find(user[0]), v.event] }
    end
  end

  def rank
    @events = Participant.all.group(:event_id).count.sort_by { |k, v| v }.reverse.map { |k, v| Event.find(k) }
  end

  def amazon
    users = Participant.where(event_id: 231).group_by { |v| v.user_id }.map { |k, v| k }
    @events = Participant.where(user_id: users).group_by { |v| v.event_id }.map { |k, v| [Event.where(id: k).first, v.count, Event.where(id: k).first.started_at] }.sort_by { |k, v| v }.reverse.select{ |v| v[2] > '2017-02-15' }.map { |v| v[0] }
  end
end
