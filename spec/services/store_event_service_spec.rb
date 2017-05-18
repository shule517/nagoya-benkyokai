require 'rails_helper'

describe StoreEventService, type: :request do

  # エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！
  describe 'atnd' do
    context '新規登録の場合', vcr: 'atnd' do
      let(:target_event) { Api::Atnd::AtndApi.find(event_id: 81945) }
      let(:event) { StoreEventService.new.call(target_event) }
      it {
        # イベント詳細
        expect(event.source).to eq 'ATND'
        expect(event.event_id).to eq 81945.to_s
        expect(event.event_url).to eq 'https://atnd.org/events/81945'
        expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
        expect(event.catch).to start_with '【ATEAM TECHとは】 ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。'
        expect(event.started_at).to eq Date.parse('2016-10-11T20:00:00.000+09:00').strftime
        expect(event.place).to eq 'エイチーム　本社'
        expect(event.address).to eq '〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F'
        expect(event.logo).to eq 'https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731'
        # expect(event.limit_over?).to eq false

        # 参加者
        expect(event.users.count).to eq event.accepted.to_i
        expect(event.participants.size).to eq event.users.count + event.owners.count

        # 開催日
        expect(event.year).to eq 2016
        expect(event.month).to eq 10
        expect(event.day).to eq 11
        expect(event.wday).to eq '火'

        # グループ情報
        expect(event.group_title).to eq nil
        expect(event.group_id).to eq nil
        expect(event.group_url).to eq nil
        expect(event.group_logo).to eq nil

        # ツイッター
        expect(event.twitter_list_url).to eq nil # UpdateTwitterList後に登録される
      }
    end
  end

  # JXUGC #14 Xamarinの場合
  describe 'connpass' do
    context '新規作成の場合', vcr: 'connpass' do
      let(:target_event) { Api::Connpass::ConnpassApi.find(event_id: 30152) }
      let(:event) { StoreEventService.new.call(target_event) }
      it {
        # イベント詳細
        expect(event.source).to eq 'connpass'
        expect(event.event_id).to eq 30152.to_s
        expect(event.event_url).to eq 'https://jxug.connpass.com/event/30152/'
        expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
        expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
        expect(event.catch).to start_with 'にゃごやでも話題の Xamarin を触ってみよう！<br>こんにちは。エクセルソフトの田淵です。 今話題の Xamarin を名古屋でも触ってみましょう！'
        expect(event.started_at).to eq Date.parse('2016-05-15T13:00:00+09:00').strftime
        expect(event.place).to eq '熱田生涯学習センター'
        expect(event.address).to eq '熱田区熱田西町2-13'
        expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
        # expect(event.limit_over?).to eq true

        # 開催日
        expect(event.year).to eq 2016
        expect(event.month).to eq 5
        expect(event.day).to eq 15
        expect(event.wday).to eq '日'

        # グループ情報
        expect(event.group_title).to eq 'JXUG'
        expect(event.group_id).to eq 1134.to_s
        expect(event.group_url).to eq 'https://jxug.connpass.com/'
        expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'

        # 参加者
        expect(event.users.count).to eq event.accepted.to_i
        expect(event.participants.size).to eq event.users.count + event.owners.count

        # ツイッター
        expect(event.twitter_list_url).to eq nil # UpdateTwitterList後に登録される
      }
    end
  end

  # リモート開発 de ナイト
  describe 'doorkeeper' do
    context '新規作成の場合', vcr: 'doorkeeper' do
      let(:target_event) { Api::Doorkeeper::DoorkeeperApi.find(event_id: 45257) }
      let(:event) { StoreEventService.new.call(target_event) }
      it {
        # イベント詳細
        expect(event.source).to eq 'Doorkeeper'
        expect(event.event_id).to eq 45257.to_s
        expect(event.event_url).to eq 'https://geekbar.doorkeeper.jp/events/45257'
        expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
        expect(event.catch).to start_with 'リモート開発、してますか？ している人も、していないけどしたい人も、集まって情報交換しましょう。'
        expect(event.started_at).to eq Date.parse('2016-06-13T10:30:00.000Z').strftime
        expect(event.place).to eq 'Club Adriana'
        expect(event.address).to eq '名古屋市中区葵1-27-37シティハイツ1F'
        expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png'
        # expect(event.limit_over?).to eq false

        # 開催日
        expect(event.year).to eq 2016
        expect(event.month).to eq 6
        expect(event.day).to eq 13
        expect(event.wday).to eq '月'

        # グループ情報
        expect(event.group_title).to eq '名古屋ギークバー'
        expect(event.group_id).to eq 1995.to_s
        expect(event.group_url).to eq 'https://geekbar.doorkeeper.jp/'
        expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg'

        # 参加者
        expect(event.users.count + 3).to eq (event.accepted).to_i # 3人非表示
        expect(event.participants.size).to eq event.users.count + event.owners.count

        # ツイッター
        expect(event.twitter_list_url).to eq nil # UpdateTwitterList後に登録される
      }
    end
  end
end
