require 'rails_helper'
include Api::Techplay

describe TechplayApi, type: :request do
  let(:api) { TechplayApi.new }

  describe '#search', vcr: '#search' do
    let(:events) { api.search }

    context 'タグが１つの場合' do
      it 'タグ情報が取得できること' do
        title = 'Mobile Act NAGOYA #6 モバイル開発者向けイベント特集'
        expect(events.find { |name, tags| name == title }.last).to eq [id: 'lightningtalks', name: 'ライトニングトーク']
      end
    end

    context 'タグが複数の場合' do
      it 'タグ情報が取得できること' do
        title = '（移転しました）名古屋ゲーム制作部　兼　Live2Dの日　6月17日（土）'
        expect(events.find { |name, tags| name == title }.last).to eq [ { id: 'game', name: 'ゲーム' }, { id: 'live2d', name: 'Live2D' }, { id: 'beginner', name: '初心者' } ]
      end
    end
  end
end
