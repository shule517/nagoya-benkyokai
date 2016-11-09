# encoding: utf-8
require 'nokogiri'
require './http'
require './event'

class Atnd
  # イベントのグループ
  # イベント参加者一覧
  # def event_users(event_id)
  #   url = "http://jxug.connpass.com/event/#{event_id}/participation/#participants"
  #   doc = Http.get_document(url)
  #   doc.css('.user_info > a.image_link').map {|link| link.attribute('href').value}
  # end

  def search(keywords, ym = nil)
    search_core(0, keywords, ym)
  end

  private

  def search_core(start, keywords, ym = nil)
    count = 100
    url = "http://api.atnd.org/events/?keyword_or=#{keywords}&count=#{count}&order=2&start=#{start.to_s}&format=json"
    url += "&ym=#{ym}" if ym != nil
    result = Http.get_json(url)

    results_returned = result[:results_returned]
    results_start = result[:results_start]
    next_start = results_start + results_returned
    events = result[:events].map {|event| AtndEvent.new(event[:event])}

    if next_start >= count
      events + search_core(next_start, keywords, ym)
    else
      events
    end
  end
end
