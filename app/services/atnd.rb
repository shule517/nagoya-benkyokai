require 'nokogiri'

class Atnd
  def search(args)
    set_param(args)
    search_core(0)
  end

  def find(args)
    set_param(args)
    search_core(0).first
  end

  private

  SEARCH_MAX_COUNT = 100

  attr_reader :keywords, :ym_list, :event_id
  def set_param(keyword: [], ym: [], event_id: nil)
    @keywords = Array(keyword)
    @ym_list = Array(ym)
    @event_id = event_id
  end

  def search_core(start)
    result = Shule::Http.get_json(request_url(start))

    results_returned = result[:results_returned]
    next_start = result[:results_start].to_i + results_returned
    events = result[:events].map { |event| AtndEvent.new(event[:event]) }

    if results_returned >= SEARCH_MAX_COUNT
      events + search_core(next_start)
    else
      events
    end
  end

  def request_url(start)
    "http://api.atnd.org/events/?start=#{start}&count=#{SEARCH_MAX_COUNT}&order=2&format=json".tap do |url|
      url << "&event_id=#{event_id}" if event_id.present?
      url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
      url << ym_list.map { |ym| "&ym=#{ym}" }.join
    end
  end
end
