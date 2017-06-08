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
    result = Shule::Http.get_json(request_url(start))

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

  def request_url(start)
    "https://connpass.com/api/v1/event/?start=#{start.to_s}&count=100&order=2".tap do |url|
      url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
      url << ym_list.map { |ym| "&ym=#{ym}" }.join
    end
  end
end
