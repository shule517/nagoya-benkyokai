require 'rails_helper'

describe Atnd, type: :request do
  let(:api) { Atnd.new }

  describe '#search' do
    context '1ページ(100件以内)の場合', vcr: '#search-1page' do
      let(:events) { api.search(keyword: '名古屋', ym: '201701') }

      it '取得した件数が~100件であること' do
        expect(events.count).to be > 0
        expect(events.count).to be <= 100
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context '2ページ(100件以上)の場合', vcr: '#search-2page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201611', '201612', '201701']) }

      it '取得した件数が100~200件であること' do
        expect(events.count).to be > 100
        expect(events.count).to be <= 200
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context '3ページ(200件以上)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201608', '201609', '201610', '201611', '201612', '201701']) }

      it '取得した件数が200~300件であること' do
        expect(events.count).to be > 200
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context 'イベントIDを指定した場合', vcr: '#search-event_id' do
      let(:events) { api.search(event_id: 81945) }

      it '指定したIDのイベントが取得できること' do
        expect(events.first.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
      end
    end
  end

  xdescribe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 81945) }

    it '取得したイベントの1件目を取得できること' do
      expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    end
  end
end
