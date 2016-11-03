require 'nokogiri'
require 'open-uri'

class Connpass
  def get_document(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    Nokogiri::HTML.parse(html, charset)
  end

  def event_users(event_id)
    url = "http://jxug.connpass.com/event/#{event_id}/participation/#participants"
    doc = get_document(url)
    doc.css('.user_info > a.image_link').map { |link| link.attribute('href').value }
  end
end
