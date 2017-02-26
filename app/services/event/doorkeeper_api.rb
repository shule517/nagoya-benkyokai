class DoorkeeperApi
  def search(keywords, ym_list)
    keywords.flat_map { |keyword| search_core(keyword, ym_list) }
  end

  def search_core(keyword, ym_list, start = 1)
    ym_list.sort!
    since_param = "&since=#{ym_list.first}01000000"
    until_param = "&until=#{ym_list.last}31235959"
    url = "https://api.doorkeeper.jp/events/?q=#{keyword}&sort=starts_at#{since_param}#{until_param}&page=#{start}"
    result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
    events = result.map { |hash| Hashie::Mash.new(hash[:event]) }
    return events + search_core(keyword, ym_list, start + 1) if events.count >= 20
    events
  end
end
