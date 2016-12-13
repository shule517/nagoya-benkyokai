# encoding: utf-8
require 'nokogiri'
require_relative './http'
require_relative './atnd_event'

class Atnd
  def search(keywords, ym_list = [])
    search_core(0, keywords, ym_list)
  end

  private
  def search_core(start, keywords, ym_list = [])
    count = 100
    url = "http://api.atnd.org/events/?keyword_or=#{keywords}&count=#{count}&order=2&start=#{start.to_s}&format=json"
    ym_list.each do |ym|
      url += "&ym=#{ym}"
    end
    result = Shule::Http.get_json(url)

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
