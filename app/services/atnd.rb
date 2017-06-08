require 'nokogiri'
require_relative './http'
require_relative './atnd_event'

class Atnd
  def search(keyword: [], ym: [])
    @keywords = Array(keyword)
    @ym_list = Array(ym)
    search_core(0)
  end

  private

  attr_reader :keywords, :ym_list
  SEARCH_MAX_COUNT = 100
  def search_core(start)
    result = Shule::Http.get_json(request_url(start))

    results_returned = result[:results_returned]
    results_start = result[:results_start].to_i
    next_start = results_start + results_returned
    events = result[:events].map { |event| AtndEvent.new(event[:event]) }

    if results_returned >= SEARCH_MAX_COUNT
      events + search_core(next_start)
    else
      events
    end
  end

  def request_url(start)
    "http://api.atnd.org/events/?keyword_or=#{keywords.join(',')}&count=#{SEARCH_MAX_COUNT}&order=2&start=#{start.to_s}&format=json".tap do |url|
      ym_list.each do |ym|
        url << "&ym=#{ym}"
      end
    end
  end
end
