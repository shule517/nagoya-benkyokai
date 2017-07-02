module Api
  module Techplay
    class TechplayApi
      def search(keyword = nil)
        doc = Api::Http.get_document(request_url(keyword))
        scraping_tags(doc)
      end

      def scraping_tags(doc)
        doc.css('#main-content .eventlist .eventlist-right .title').map do |event_doc|
          title = event_doc.css('a').first.text
          tags = event_doc.css('.tags > a').map do |a|
            id = a.attribute('href').text.gsub('https://techplay.jp/tag/', '')
            { id: id, name: a.text }
          end
          [title, tags]
        end
      end

      def request_url(keyword)
        keyword = URI.escape(keyword) if keyword.present?
        url = "https://techplay.jp/event/search?keyword=#{keyword}&pref=23&tag=&from=&to=&sort=started_asc"
      end
    end
  end
end
