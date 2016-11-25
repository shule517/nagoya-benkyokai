# encoding: utf-8
require_relative './connpass'
require_relative './doorkeeper'
require_relative './atnd'

def get_events(date)
  apis = []
  apis << Connpass.new
  apis << Doorkeeper.new
  # apis << Atnd.new
  events = []
  apis.each do |api|
    events += api.search('名古屋', date)
  end
  events.select! {|event| event.address.include?('名古屋')}
  today = Time.now.strftime("%Y-%m-%d")
  puts "today:#{today}"
  events.select! {|event| event.started_at >= today}
  events.sort_by! {|event| event.started_at}
end

puts "start"
events = get_events(201611)

require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @data = events
  erb :index
end

get '/date/:date' do |date|
  @data = get_events(date)
  erb :index
end

get '/event' do
  "event"
end

get '/event/:event_id' do |event_id|
  @data = events.select{|event| event.event_id == event_id.to_i}.first
  erb :event
end

get '/group/:group_id' do |group_id|
  "group: #{group_id}"
end
