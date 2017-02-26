class ConnpassApi
  def search(keywords, ym_list, start = 0)
    ym = ym_list.map { |ym| "&ym=#{ym}" }.join
    url = "https://connpass.com/api/v1/event/?keyword_or=#{keywords.join(',')}&count=100&order=2&start=#{start + 1}#{ym}"
    result = Shule::Http.get_json(url)
    events = result[:events].map { |hash| Hashie::Mash.new(hash) }
    next_start = result[:results_returned] + start
    return events + search(keywords, ym_list, next_start) if next_start < result[:results_available]
    events
  end
end
