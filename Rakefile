# coding: UTF-8

require 'rake/testtask'
require_relative './app/event_collector'

task :default => [:test]

Rake::TestTask.new do |test|
  # テスト対象ファイルの指定
  test.test_files = Dir[ 'test/**/*test.rb' ]
  test.verbose = true
end

task :update do
  collecor = EventCollector.new
  collecor.update_twitter([201612, 201701, 201702])
  collecor.update
end
