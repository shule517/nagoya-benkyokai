require 'rails_helper'
include Api::Techplay

describe TechplayApi, type: :request do
  let(:api) { TechplayApi.new }

  describe '#search' do
    context 'タグが１つの場合' do
      let(:events) { api.search }
      it 'タグ情報が取得できること', vcr: '#search-tag' do
        title = '機械学習　名古屋　第11回勉強会　【会場：東建ホール】'
        expect(events.find { |name, tags| name == title }.last).to eq [id: 'machinelearning', name: '機械学習']
      end
    end

    context 'タグが複数の場合' do
      let(:events) { api.search }
      it 'タグ情報が取得できること', vcr: '#search-tags' do
        title = '（移転しました）名古屋ゲーム制作部　兼　Live2Dの日　7月8日（土）'
        expect(events.find { |name, tags| name == title }.last).to eq [ { id: 'game', name: 'ゲーム' }, { id: 'live2d', name: 'Live2D' }, { id: 'beginner', name: '初心者' } ]
      end
    end

    context 'keyword指定した場合' do
      let(:events) { api.search('機械学習') }
      it '指定キーワードのタグ情報が取得できること', vcr: '#search-keyword' do
        expect(events).to include ['機械学習　名古屋　第11回勉強会　【会場：東建ホール】', [{ id: 'machinelearning', name: '機械学習' }]]
        expect(events).to include ['機械学習　名古屋　第１１回の懇親会', [{ id: 'machinelearning', name: '機械学習' }]]
      end
    end
  end
end
