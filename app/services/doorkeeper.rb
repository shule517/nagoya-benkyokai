require 'nokogiri'
require_relative './http'
require_relative './doorkeeper_event'

class Doorkeeper
  def search(keywords, ym_list = [])
    events = []
    keywords.take(5).each do |keyword|
      events += search_core(0, keyword, ym_list.first)
    end
    events
  end

private
  def search_core(start, keyword, ym)
    url = "https://api.doorkeeper.jp/events/?q=#{keyword}&sort=starts_at#{ym.nil? ? '' : "&since=#{ym}01000000"}&page=#{start.to_s}"
    begin
      result = Shule::Http.get_json(url)
      if result.nil?
        raise
      end
      events = result.map { |event| DoorkeeperEvent.new(event[:event]) }
    rescue
      puts 'sleep(301)'
      sleep(301)
      puts 'retry'
      retry
    end

    if events.count == 20
      events + search_core(start + 1, keyword, ym)
    else
      events
    end
  end
end
