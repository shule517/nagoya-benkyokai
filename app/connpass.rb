# encoding: utf-8
require 'nokogiri'
require_relative './http'
require_relative './event'

class Connpass
  def search(keywords, ym = nil)
    search_core(0, keywords, ym)
  end

  private
  def search_core(start, keywords, ym = nil)
    url = "http://connpass.com/api/v1/event/?keyword_or=#{keywords}&count=100&order=2&start=#{start.to_s}"
    url += "&ym=#{ym}" if ym != nil
    result = Shule::Http.get_json(url)

    results_returned = result[:results_returned]
    results_available = result[:results_available]
    results_start = result[:results_start]
    next_start = results_start + results_returned
    events = result[:events].map {|event| ConnpassEvent.new(event)}

    if next_start < results_available
      events + search_core(next_start, keywords, ym)
    else
      events
    end
  end
end
