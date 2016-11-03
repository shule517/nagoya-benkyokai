# encoding: utf-8
require './connpass'

api = Connpass.new
events = api.search('名古屋').sort_by {|event| event.started_at}
events.each do |event|
  puts "#{event.started_at[0..9]}【#{event.title}】 #{event.catch}　◆#{event.place} #{event.accepted}/#{event.limit} #{event.limit_over? ? "定員" : "まだいけます"}"
end
