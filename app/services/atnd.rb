require 'nokogiri'
require_relative './http'
require_relative './atnd_event'

class Atnd
  def search(keyword: [], ym: [], event_id: nil)
    @keywords = Array(keyword)
    @ym_list = Array(ym)
    @event_id = event_id
    search_core(0)
  end

  private

  attr_reader :keywords, :ym_list, :event_id
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
    "http://api.atnd.org/events/?start=#{start}&count=#{SEARCH_MAX_COUNT}&order=2&format=json".tap do |url|
      url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
      url << ym_list.map { |ym| "&ym=#{ym}" }.join
      url << "&event_id=#{event_id}" if event_id.present?
    end
  end
end
