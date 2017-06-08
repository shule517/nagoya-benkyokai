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
  def search_core(start)
    count = 100
    url = "http://api.atnd.org/events/?keyword_or=#{keywords.join(',')}&count=#{count}&order=2&start=#{start.to_s}&format=json"
    ym_list.each do |ym|
      url += "&ym=#{ym}"
    end
    result = Shule::Http.get_json(url)

    results_returned = result[:results_returned]
    results_start = result[:results_start].to_i
    next_start = results_start + results_returned
    events = result[:events].map { |event| AtndEvent.new(event[:event]) }

    if results_returned >= count
      events + search_core(next_start)
    else
      events
    end
  end
end
