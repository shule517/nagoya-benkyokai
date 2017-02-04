# encoding: utf-8
require 'nokogiri'
require_relative './http'
require_relative './connpass_event'

class Connpass
  def search(keywords, ym_list = [])
    search_core(1, keywords, ym_list)
  end

private
  def search_core(start, keywords, ym_list = [])
    url = "http://connpass.com/api/v1/event/?keyword_or=#{keywords.join(',')}&count=100&order=2&start=#{start.to_s}"
    ym_list.each do |ym|
      url += "&ym=#{ym}"
    end
    result = Shule::Http.get_json(url)

    results_returned = result[:results_returned]
    results_available = result[:results_available]
    results_start = result[:results_start]
    next_start = results_start + results_returned
    events = result[:events].map { |event| ConnpassEvent.new(event) }

    if next_start < results_available
      events + search_core(next_start, keywords, ym_list)
    else
      events
    end
  end
end
