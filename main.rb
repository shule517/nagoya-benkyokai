# encoding: utf-8
require './connpass'

puts "start"
api = Connpass.new
events = api.search('名古屋', 201611).sort_by {|event| event.started_at}
# events.each do |event|
#   puts "#{event.started_at[0..9]}【#{event.title}】 #{event.catch}　◆#{event.place} #{event.accepted}/#{event.limit} #{event.limit_over? ? "定員" : "まだいけます"}"
# end

require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @data = events
  erb :index
end

get '/date/:date' do |date|
  @data = api.search('名古屋', date).sort_by {|event| event.started_at}
  erb :index
end

get '/event' do
  "event"
end

get '/event/:event_id' do |event_id|
  "event: #{event_id}"
end

get '/group/:group_id' do |group_id|
  "group: #{group_id}"
end
