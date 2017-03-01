module Api
  module Atnd
    class AtndApi
      COUNT = 100
      def search(keyword: [], ym: [], start: 0)
        keyword_option = keyword.empty? ? '' : "&keyword_or=#{Array(keyword).join(',')}"
        ym_option = Array(ym).map { |ym| "&ym=#{ym}" }.join
        url = "http://api.atnd.org/events/?count=#{COUNT}&order=2&start=#{start + 1}&format=json#{keyword_option}#{ym_option}"

        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| AtndEvent.new(hash) }
        next_start = result[:results_returned] + result[:results_start].to_i
        if result[:results_returned] >= COUNT
          events + search(keyword: keyword, ym: ym, start: next_start) 
        else
          events
        end
      end
    end
  end
end
