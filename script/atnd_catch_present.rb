require './script/script_helper'

# AtndApiから取得できる「catch」の調査
# 1000件取得したけど 全て中身はからっぽだった
events = (81000 .. 82000).map do |event_id|
  url = "http://api.atnd.org/events/?event_id=#{event_id}&order=2&format=json"
  result = Shule::Http.get_json(url)
  events = result[:events]
  events.first[:event] unless events.empty?
end
events.compact!
catches = events.select { |event| event[:catch].present? }

puts "catches.count:#{catches.count}" # -> catches.count:0
p catches # -> []
