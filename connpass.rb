# encoding: utf-8
require 'nokogiri'
require './http'

class Connpass
  def event_users(event_id)
    url = "http://jxug.connpass.com/event/#{event_id}/participation/#participants"
    doc = Http.get_document(url)
    doc.css('.user_info > a.image_link').map { |link| link.attribute('href').value }
  end

  def search(keywords)
    search_core(keywords, 0)
  end

  private
  def search_core(keywords, start)
    url = "http://connpass.com/api/v1/event/?keyword_or=#{keywords}&ym=201611&count=100&order=2&start=#{start.to_s}"
    result = Http.get_json(url)

    results_returned = result[:results_returned]
    results_available = result[:results_available]
    results_start = result[:results_start]
    next_start = results_start + results_returned
    events = result[:events]

    if next_start < results_available
      events + search(keywords, next_start)
    else
      events
    end
  end
end
