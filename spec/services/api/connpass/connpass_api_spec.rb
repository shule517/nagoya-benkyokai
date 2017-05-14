require 'rails_helper'
include Api::Connpass

describe ConnpassApi, type: :request do
  let(:api) { ConnpassApi }
  describe '#search' do
    context '１ページ(１００件以内)の場合', vcr: '#search-1page' do
      let(:events) { api.search(keyword: '名古屋', ym: '201701') }
      it { expect(events.count).to be < 100 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '２ページ(１００件以上)の場合', vcr: '#search-2page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201610', '201611']) }
      it { expect(events.count).to be >= 100 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '３ページ(２００件以上)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701']) }
      it { expect(events.count).to be >= 200 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context 'イベントIDを指定した場合', vcr: '#search-event_id' do
      let(:events) { api.search(event_id: 30152) }
      it { expect(events.first.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会' }
    end
  end

  describe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 30152) }
    it { expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会' }
  end
end
