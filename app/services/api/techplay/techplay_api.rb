module Api
  module Techplay
    class TechplayApi
      def search
        url = 'https://techplay.jp/event/search?keyword=&pref=23&tag=&from=&to=&sort=started_asc'
        doc = Api::Http.get_document(url)

        events = doc.css('#main-content .eventlist .eventlist-right .title').map do |event_doc|
          title = event_doc.css('a').first.text
          tags = event_doc.css('.tags > a').map do |a|
            id = a.attribute('href').text.gsub('https://techplay.jp/tag/', '')
            { id: id, name: a.text }
          end
          [title, tags]
        end
        events
      end
    end
  end
end
