# encoding: utf-8
namespace :event do
  desc "イベント情報を収集"
  task :update => :environment do
    EventUpdater.call
  end
end
