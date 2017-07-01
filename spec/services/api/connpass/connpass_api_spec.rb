require 'rails_helper'
include Api::Connpass

describe ConnpassApi, type: :request do
  let(:api) { ConnpassApi.new }

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
      let(:events) { api.search(keyword: '名古屋', ym: ['201610', '201611']) }

      it '取得した件数が100~200件であること' do
        expect(events.count).to be > 100
        expect(events.count).to be <= 200
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context '3ページ(200件以上)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701', '201702']) }
      it '取得した件数が200~件であること' do
        expect(events.count).to be > 200
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context 'イベントIDを指定した場合', vcr: '#search-event_id' do
      let(:events) { api.search(event_id: 30152) }

      it '指定したIDのイベントが取得できること' do
        expect(events.first.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
      end
    end

    context 'グループIDを指定した場合', vcr: '#search-series_id' do
      let(:events) { api.search(series_id: 3740) } # NKC-UG 名古屋 https://msp-nkc.connpass.com/

      it '指定したグループのイベントが取得できること' do
        titles = events.map(&:title)
        expect(titles).to include '【NKC生限定】名古屋で始めるAI を使いこなせ！ Cognitive Services 勉強会！' # https://msp-nkc.connpass.com/event/61174/
      end
    end
  end

  describe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 30152) }

    it '取得したイベントの1件目を取得できること' do
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
    end
  end
end
