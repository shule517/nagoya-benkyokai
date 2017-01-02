# encoding: utf-8
require 'nokogiri'
require_relative './http'
require_relative './doorkeeper_event'

class Doorkeeper
  def search(keywords, ym_list = [])
    search_core(0, keywords, ym_list.first)
  end

  private
  def search_core(start, keywords, ym)
    url = "https://api.doorkeeper.jp/events/?q=#{keywords.first}&sort=starts_at#{ym.nil? ? "" : "&since=#{ym}01000000"}&page=#{start.to_s}"
    result = Shule::Http.get_json(url)
    events = result.map {|event| DoorkeeperEvent.new(event[:event])}

    if events.count == 20
      events + search_core(start+1, keywords, ym)
    else
      events
    end
  end
end
