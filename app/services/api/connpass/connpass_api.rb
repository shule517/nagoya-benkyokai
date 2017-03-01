module Api
  module Connpass
    class ConnpassApi
      def search(keyword: nil, ym: nil, start: 0)
        keyword_option = keyword.empty? ? '' : "&keyword_or=#{Array(keyword).join(',')}"
        ym_option = Array(ym).map { |ym| "&ym=#{ym}" }.join
        url = "https://connpass.com/api/v1/event/?count=100&order=2&start=#{start + 1}#{keyword_option}#{ym_option}"

        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| ConnpassEvent.new(hash) }
        next_start = result[:results_returned] + start
        if next_start < result[:results_available]
          events + search(keyword: keyword, ym: ym, start: next_start)
        else
          events
        end
      end
    end
  end
end
