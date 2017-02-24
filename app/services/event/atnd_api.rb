class AtndApi
  COUNT = 100
  def search(keywords, ym_list, start = 0)
    ym = ym_list.map { |ym| "&ym=#{ym}" }.join
    url = "http://api.atnd.org/events/?keyword_or=#{keywords.join(',')}&count=#{COUNT}&order=2&start=#{start+1}&format=json#{ym}"
    result = Shule::Http.get_json(url)
    events = result.events
    next_start = result.results_returned + result.results_start.to_i
    if result.results_returned >= COUNT
      events + search(keywords, ym_list, next_start)
    else
      events
    end
  end
end
