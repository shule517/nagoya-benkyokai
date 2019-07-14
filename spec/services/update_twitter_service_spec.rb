require 'rails_helper'

describe UpdateEventService, type: :request do
  before(:each) do
    twitter.lists.each do |list|
      p "削除:#{list[:id]}"
      twitter.destroy_list(list[:id])
    end
  end
  let(:twitter) { TwitterClient.new }
  let(:service) { UpdateTwitterService.new }
  let(:event) { FactoryGirl.create(:event) }
  let(:events) { [event] }

  it 'ツイッターリストの新規作成', vcr: '#create' do
    expect(event.twitter_list_name).to eq nil
    expect(event.twitter_list_url).to eq nil
    expect(twitter.lists).to be_empty

    service.call(events)
    expect(event.twitter_list_name).to eq 'JXUGC #14 Xamarin ハンズオン'
    expect(event.twitter_list_url).to eq 'https://twitter.com/benkyo_dev/lists/jxugc-14-xamarin'
    expect(twitter.lists.size).to eq 1
  end

  it '重複してツイッターリストが作成されないこと', vcr: '#re-create' do
    expect(event.twitter_list_name).to eq nil
    expect(event.twitter_list_url).to eq nil
    expect(twitter.lists).to be_empty

    # 新規作成
    service.call(events)
    expect(event.twitter_list_name).to eq 'JXUGC #14 Xamarin ハンズオン'
    expect(event.twitter_list_url).to eq 'https://twitter.com/benkyo_dev/lists/jxugc-14-xamarin'
    expect(twitter.lists.size).to eq 1

    # ２度めはスルーされること
    service.call(events)
    expect(event.twitter_list_name).to eq 'JXUGC #14 Xamarin ハンズオン'
    expect(event.twitter_list_url).to eq 'https://twitter.com/benkyo_dev/lists/jxugc-14-xamarin'
    expect(twitter.lists.size).to eq 1
  end

  it 'ツイッターリストが更新されること', vcr: '#update' do
    expect(event.twitter_list_name).to eq nil
    expect(event.twitter_list_url).to eq nil
    expect(twitter.lists).to be_empty

    # 新規作成
    service.call(events)
    expect(event.twitter_list_name).to eq 'JXUGC #14 Xamarin ハンズオン'
    expect(event.twitter_list_url).to eq 'https://twitter.com/benkyo_dev/lists/jxugc-14-xamarin'
    expect(twitter.lists.size).to eq 1

    # タイトル変更がされること
    event.title = 'title changed'
    service.call(events)
    expect(event.twitter_list_name).to eq 'title changed'
    expect(event.twitter_list_url).to eq 'https://twitter.com/benkyo_dev/lists/title-changed'
    expect(twitter.lists.size).to eq 1
  end
end
