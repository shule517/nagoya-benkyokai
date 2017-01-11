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
  begin
    collecor.update_twitter([201701, 201702, 201703])
  rescue => e
    p e
  end

  begin
    collecor.update
  rescue => e
    p e
  end
end
