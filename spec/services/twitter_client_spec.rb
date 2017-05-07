require 'rails_helper'

describe TwitterClient do
  let(:client) { TwitterClient.new }

  it 'tweetできること' do
    expect{ client.tweet('テスト') }.not_to raise_error
  end

  describe 'リスト機能' do
    let(:name) { "テスト#{Time.now.strftime('%Y%m%d %H%M%S.%L')}" }
    let(:description) { '詳細説明だよ' }

    it 'リストが作成できること' do
      list = client.create_list(name, description)
      expect(list.name).to eq name
      expect(list.description).to eq description
      expect(list.id).to be > 0
    end

    it 'リストが更新できること' do
      list = client.create_list(name, description)
      updated_name = "更新:#{name}"
      updated_description = "更新:#{description}"
      updated_list = client.update_list(list.id, updated_name, updated_description)
      expect(updated_list.name).to eq updated_name
      expect(updated_list.description).to eq updated_description
      expect(updated_list.id).to eq list.id
    end

    it 'リストIDを指定して、リストが取得できること' do
      list = client.create_list(name, description)
      expect(client.list(list.id).name).to eq name
    end

    describe 'リストの存在チェック' do
      it 'リストが存在しない場合' do
        list = client.create_list(name, description)
        expect(client.list_exists?(list.id)).to eq true
      end

      it 'リストが存在する場合' do
        expect(client.list_exists?(1234567890)).to eq false
      end
    end

    it 'リストが削除できること' do
      list = client.create_list(name, description)
      client.destroy_list(list.id)
      sleep 1
      expect(client.list_exists?(list.id)).to eq false
    end

    it 'リストの一覧が取得できること' do
      expect(client.lists.size).to be > 0
    end

    describe 'リストメンバー' do
      context '権限がある場合' do
        it 'メンバーを追加できること' do
          list = client.create_list(name, description)
          client.add_list_member(list.id, 'shule517')
          members = client.list_members(list.id)
          expect(members.to_a.size).to eq 1

          member = members.first
          expect(member.screen_name).to eq 'shule517'
          expect(member.name).to eq 'しっかりシュール'
        end
      end

      context '権限がない場合' do
        it 'メンバーを追加できないこと' do
          list = client.create_list(name, description)
          client.add_list_member(list.id, 'shule517')
          members = client.list_members(list.id)
          expect(members.to_a.size).to eq 1
        end
      end

      describe 'メンバーの確認ができること' do
        it '登録者がいない場合' do
          list = client.create_list(name, description)
          members = client.list_members(list.id)
          expect(members.to_a.size).to eq 0
          # TODO 権限がないユーザを登録した場合
        end

        it '登録者が複数の場合' do
          list = client.create_list(name, description)
          client.add_list_member(list.id, ['shule517', 'nagoya_lambda'])
          members = client.list_members(list.id)
          expect(members.to_a.size).to eq 2
          # TODO 権限がないユーザを登録した場合
        end
      end
    end
  end
end

describe TwitterClient do
  let(:client) { TwitterClient.new }

  describe 'リスト名称の文字数チェック' do
    it '半角英数：25文字以下の場合は、リストが作成できる' do
      expect(client.check_list_name('ABCDEFGHIJKLMNOPQRSTUVWXY')).to eq true   # 25文字 -> o
      expect(client.check_list_name('ABCDEFGHIJKLMNOPQRSTUVWXYZ')).to eq false # 26文字 -> x
    end

    it '全角文字：55バイト以下の場合は、リストが作成できる' do
      expect(client.check_list_name('①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱')).to eq true    # 54byte -> o
      expect(client.check_list_name('①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱1')).to eq true   # 55byte -> o
      expect(client.check_list_name('①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱12')).to eq false # 56byte -> x
      expect(client.check_list_name('①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲')).to eq false # 57byte -> x
    end
  end

  describe 'リスト詳細の文字数チェック' do
    it '半角英数：100文字以下の場合は、リストが作成できる' do
      expect(client.check_list_desc('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890')).to eq true   # 100byte -> o
      expect(client.check_list_desc('12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901')).to eq false # 101byte -> x
    end

    it '全角文字：255バイト以下の場合は、リストが作成できる' do
      expect(client.check_list_desc('１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５')).to eq true   # 255 byte -> o
      expect(client.check_list_desc('１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４123')).to eq true # 255 byte -> o
      expect(client.check_list_desc('１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５A')).to eq false # 256 byte -> x
    end
  end
end
