require 'rails_helper'

describe Doorkeeper, type: :request do
  let(:api) { Doorkeeper.new }

  describe '#search' do
    context '1ページ(20件以内)の場合', vcr: '#search-1page' do
      let(:events) { api.search(keyword: '豊橋', ym: '201701') }

      it '取得した件数が~20件であること' do
        expect(events.count).to be > 0
        expect(events.count).to be <= 20
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    xcontext '2ページ(40件以内)の場合', vcr: '#search-2page' do
      let(:events) { api.search(keyword: '愛知', ym: ['201612', '201701']) }

      it '取得した件数が20~40件であること' do
        expect(events.count).to be > 20
        expect(events.count).to be <= 40
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    context '3ページ(40件以上)の場合', vcr: '#search-3page' do
      let(:events) { api.search(keyword: '愛知', ym: ['201612', '201701']) }

      it '取得した件数が40~件であること' do
        expect(events.count).to be > 40
      end

      it 'イベントを重複して取得していないこと' do
        expect(events.uniq.size).to eq events.size
      end
    end

    xcontext '検索キーワードが複数の場合', vcr: '#search-keywords' do
      let(:events) { api.search(keyword: ['名古屋', '愛知'], ym: '201701') }

      it 'イベントが取得できること' do
        expect(events.count).to be > 1
      end
    end

    xcontext 'イベントIDを指定した場合' do
      context 'イベントが存在する場合', vcr: '#search-event_id-exist' do
        let(:events) { api.search(event_id: 45257) }

        it '指定したIDのイベントが取得できること' do
          expect(events.first.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
        end
      end

      context 'イベントが存在しない場合', vcr: '#search-event_id-not_exist' do
        let(:events) { api.search(event_id: 47375) }

        it '取得結果が空であること' do
          expect(events).to be_empty
        end
      end
    end
  end

  xdescribe '#find', vcr: '#find' do
    let(:event) { api.find(event_id: 45257) }

    it '取得したイベントの1件目を取得できること' do
      expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
    end
  end
end
