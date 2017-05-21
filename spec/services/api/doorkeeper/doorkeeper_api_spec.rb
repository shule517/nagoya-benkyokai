require 'rails_helper'
include Api::Doorkeeper

describe DoorkeeperApi, type: :request do
  let(:api) { DoorkeeperApi }
  describe '#search' do
    context '１ページ(２０件以内)の場合', vcr: '#search-1page' do
      let(:events) { api.search(keyword: '豊橋', ym: '201701') }
      it { expect(events.count).to be < 20 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '２ページ(４０件以内)の場合', vcr: '#search-2page' do
      let(:events) { api.search(keyword: '愛知', ym: ['201612', '201701']) }
      it { expect(events.count).to be > 20 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '３ページ(６０件以内)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: '名古屋', ym: ['201610', '201611', '201612']) }
      it { expect(events.count).to be > 40 }
      it { expect(events.uniq.size).to eq events.size }
    end

    context '検索キーワードが複数の場合', vcr: '#search-keywords' do
      let(:events) { api.search(keyword: ['名古屋', '愛知'], ym: '201701') }
      it { expect(events.count).to be > 1 }
    end

    context 'イベントIDを指定した場合' do
      context 'イベントが存在する場合', vcr: '#search-event_id-exist' do
        let(:events) { api.search(event_id: 45257) }
        it { expect(events.first.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー' }
      end
      context 'イベントが存在しない場合', vcr: '#search-event_id-not_exist' do
        let(:events) { api.search(event_id: 47375) }
        it { expect(events.empty?).to eq true }
      end
    end
  end

  describe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 45257) }
    it { expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー' }
  end
end
