# coding: UTF-8

require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |test|
  # テスト対象ファイルの指定
  test.test_files = Dir[ 'test/**/*test.rb' ]
  test.verbose = true
end
