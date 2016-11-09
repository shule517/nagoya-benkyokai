# encoding: utf-8
require 'nokogiri'
require './http'
require './event'

class Doorkeeper
  # イベントのグループ
  # イベント参加者一覧
  def event_users(event_id)
    url = "https://geekbar.doorkeeper.jp/events/#{event_id}/participants"
    doc = Http.get_document(url)
    doc.css('.user-profile-details > div.user-name').map {|link| link.children.text}
  end

  def search(keywords, ym = nil)
    search_core(0, keywords, ym)
  end

  private

  def search_core(start, keywords, ym = nil)
    url = "https://api.doorkeeper.jp/events/?q=#{keywords}&sort=starts_at#{ym.nil? ? "" : "&since=#{ym}01000000"}&page=#{start.to_s}"
    result = Http.get_json(url)
    events = result.map {|event| DoorkeeperEvent.new(event[:event])}

    if events.count == 25
      events + search(start+1, keywords)
    else
      events
    end
  end
end
