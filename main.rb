# encoding: utf-8
require './connpass'
require './doorkeeper'

puts "start"
apis = []
apis << Connpass.new
apis << Doorkeeper.new
events = []
apis.each do |api|
  events += api.search('名古屋', 201611)
end
events.sort_by! {|event| event.started_at}

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
