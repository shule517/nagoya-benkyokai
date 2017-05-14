require 'rails_helper'
include Api::Atnd

describe AtndApi, type: :request do
  let(:api) { AtndApi }
  describe '#search' do
    context '１ページ(１００件以内)の場合', vcr: '#search-1page' do
      let(:events) { api.search(keyword: '名古屋', ym: '201701') }
      it { expect(events.count).to be < 100 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '２ページ(１００件以上)の場合', vcr: '#search-2page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201611', '201612', '201701']) }
      it { expect(events.count).to be > 100 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '３ページ(２００件以上)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201608', '201609', '201610', '201611', '201612', '201701']) }
      it { expect(events.count).to be > 200 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context 'イベントIDを指定した場合', vcr: '#search-event_id' do
      let(:events) { api.search(event_id: 81945) }
      it { expect(events.first.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！' }
    end
  end

  describe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 81945) }
    it { expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！' }
  end
end
