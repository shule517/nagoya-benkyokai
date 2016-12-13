#encoding: utf-8
require_relative './connpass'
require_relative './doorkeeper'
require_relative './atnd'

class EventCollecter
  class << self
    def search(date)
      apis = []
      apis << Connpass.new
      apis << Doorkeeper.new
      events = []
      apis.each do |api|
        events += api.search('名古屋', date)
      end

      atnd_events = Atnd.new.search('名古屋', date)
      ngwords = ["仏教", "クリスマスパーティ", "テロリスト", "国際交流パーティ", "社会人基礎力"]
      atnd_events.select! {|event| ngwords.all? {|ngword| !event.title.include?(ngword)} }
      events += atnd_events

      places = ['愛知', '名古屋', '豊橋']
      events.select! {|event| places.any? {|place| event.address.include?(place)}}
      today = Time.now.strftime("%Y-%m-%d")
      puts "today:#{today}"
      events.select! {|event| event.started_at >= today}
      events.sort_by! {|event| event.started_at}
    end
  end
end
