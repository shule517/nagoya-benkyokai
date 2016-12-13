# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require_relative './event_collecter'

puts "start"
events = EventCollecter.search([201612, 201701, 201702])

get '/' do
  @data = events
  erb :index
end

get '/date/:date' do |date|
  @data = EventCollecter.search(date)
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
