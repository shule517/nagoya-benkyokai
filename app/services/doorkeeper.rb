require 'nokogiri'
require_relative './http'
require_relative './doorkeeper_event'

class Doorkeeper
  def search(args)
    set_param(args)
    events = []
    if event_id.present?
      events += search_core(1, nil)
    else
      keywords.take(5).each do |keyword|
        events += search_core(1, keyword)
      end
    end
    events
  end

  def find(args)
    search(args).first
  end

  private

  def set_param(keyword: [], ym: [], event_id: nil)
    @keywords = Array(keyword)
    @ym_list = Array(ym)
    @event_id = event_id
  end

  attr_reader :keywords, :ym_list, :event_id
  def search_core(start, keyword)
    result = Shule::Http.get_json(request_url(start, keyword), Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
    return [DoorkeeperEvent.new(result[:event])] if result.class == Hash
    events = result.map { |event| DoorkeeperEvent.new(event[:event]) }

    if events.count == 20
      events + search_core(start + 1, keyword)
    else
      events
    end
  rescue Net::HTTPServerException
    []
  end

  def request_url(start, keyword)
    if event_id.present?
      "https://api.doorkeeper.jp/events/#{event_id}"
    else
      ym = ym_list.first
      "https://api.doorkeeper.jp/events/?sort=starts_at&page=#{start.to_s}".tap do |url|
        url << "&q=#{keyword}" if keyword.present?
        url << "&since=#{ym}01000000" if ym.present?
      end
    end
  end
end
