require 'nokogiri'
require_relative './http'
require_relative './connpass_event'

class Connpass
  def search(keyword: [], ym: [])
    @keywords = Array(keyword)
    @ym_list = Array(ym)
    search_core(1)
  end

  private

  attr_reader :keywords, :ym_list
  def search_core(start)
    url = "https://connpass.com/api/v1/event/?keyword_or=#{keywords.join(',')}&count=100&order=2&start=#{start.to_s}"
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
      events + search_core(next_start)
    else
      events
    end
  end
end
