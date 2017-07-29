module EventsHelper

  def display_day_format(day)
    day.started_at.strftime("%Y/%m/%d(#{%w(日 月 火 水 木 金 土)[Time.now.wday]})") if day.present?
  end

  def link_to_google_map(place)
    "https://maps.google.co.jp/maps?q=#{place}"
  end
end
