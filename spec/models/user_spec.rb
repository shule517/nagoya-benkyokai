require 'rails_helper'

describe User do
  before(:all) do
    #connpass
    User.create(name: 'user_connpass_nothing',  connpass_id: 'nothing')                                     # SNSなし
    User.create(name: 'user_connpass_twitter',  connpass_id: 'twitter', twitter_id: 'twitter_connpass')     # twiter
    User.create(name: 'user_connpass_facebook', connpass_id: 'facebook', facebook_id: 'facebook_connpass')  # facebook
    User.create(name: 'user_connpass_github',   connpass_id: 'github', github_id: 'github_connpass')        # github
    User.create(name: 'user_connpass_all',      connpass_id: 'all',                                         # 全て登録
      twitter_id: 'twitter_connpass_all', facebook_id: 'facebook_connpass_all', github_id: 'github_connpass_all')

    #atnd
    User.create(name: 'user_atnd_nothing',  atnd_id: 'nothing')                                 # SNSなし
    User.create(name: 'user_atnd_twitter',  atnd_id: 'twitter', twitter_id: 'twitter_atnd')     # twitter
    User.create(name: 'user_atnd_facebook', atnd_id: 'facebook', facebook_id: 'facebook_atnd')  # facebook
    User.create(name: 'user_atnd_github',   atnd_id: 'github', github_id: 'github_atnd')        # github
    User.create(name: 'user_atnd_all',      atnd_id: 'all',                                     # 全て登録
      twitter_id: 'twitter_atnd_all', facebook_id: 'facebook_atnd_all', github_id: 'github_atnd_all')

    #Doorkeeper
    User.create(name: 'user_door_nothing')                                    # SNSなし
    User.create(name: 'user_door_twitter',  twitter_id: 'twitter_door')       # twitter
    User.create(name: 'user_door_facebook', facebook_id: 'facebook_door')     # facebook
    User.create(name: 'user_door_github',   github_id: 'github_door')         # github
    User.create(name: 'user_door_linkedin', linkedin_id: 'linkedin_door')     # linkedin
    User.create(name: 'user_door_all',                                        # 全て登録
      twitter_id: 'twitter_door_all', facebook_id: 'facebook_door_all', github_id: 'github_door_all', linkedin_id: 'linkedin_door_all')
  end

  describe '#find_connpass' do
    it 'connpass-idで紐づけ' do
      expect(User.find_connpass('nothing', nil, nil, nil).name).to eq 'user_connpass_nothing'
    end
    it 'twitter-idで紐づけ' do
      expect(User.find_connpass(nil, 'twitter_connpass', nil, nil).name).to eq 'user_connpass_twitter'
    end
    it 'facebook-idで紐づけ' do
      expect(User.find_connpass(nil, nil, 'facebook_connpass', nil).name).to eq 'user_connpass_facebook'
    end
    it 'github-idで紐づけ' do
      expect(User.find_connpass(nil, nil, nil, 'github_connpass').name).to eq 'user_connpass_github'
    end
  end

  describe '#find_atnd' do
    it 'atnd-idで紐づけ' do
      expect(User.find_atnd('nothing', nil, nil).name).to eq 'user_atnd_nothing'
    end
    it 'twitter-idで紐づけ' do
      expect(User.find_atnd(nil, 'twitter_atnd', nil).name).to eq 'user_atnd_twitter'
    end
    it 'facebook-idで紐づけ' do
      expect(User.find_atnd(nil, nil, 'facebook_atnd').name).to eq 'user_atnd_facebook'
    end
  end

  describe '#find_doorkeeper' do
    it 'twitter-idで紐づけ' do
      expect(User.find_doorkeeper('twitter_door', nil, nil, nil).name).to eq 'user_door_twitter'
    end
    it 'facebook-idで紐づけ' do
      expect(User.find_doorkeeper(nil, 'facebook_door', nil, nil).name).to eq 'user_door_facebook'
    end
    it 'github-idで紐づけ' do
      expect(User.find_doorkeeper(nil, nil, 'github_door', nil, nil).name).to eq 'user_door_github'
    end
    it 'linkedin-idで紐づけ' do
      expect(User.find_doorkeeper(nil, nil, nil, 'linkedin_door', nil).name).to eq 'user_door_linkedin'
    end
    context 'SNSが登録されていない場合' do
      it '名前で紐付けられること' do
        expect(User.find_doorkeeper(nil, nil, nil, nil, 'user_door_nothing').name).to eq 'user_door_nothing'
      end
      it '名前が同じでも、SNSが登録されているユーザとは紐付かないこと' do
        expect(User.find_doorkeeper(nil, nil, nil, nil, 'user_connpass_twitter')).to eq nil
      end
    end
  end

  describe '#find_social' do
    it 'twitter-idで紐づけ' do
      expect(User.find_social('twitter_door', nil, nil).name).to eq 'user_door_twitter'
    end
    it 'facebook-idで紐づけ' do
      expect(User.find_social(nil, 'facebook_door', nil).name).to eq 'user_door_facebook'
    end
    it 'github-idで紐づけ' do
      expect(User.find_social(nil, nil, 'github_door').name).to eq 'user_door_github'
    end
    it 'linked-idで紐づけ' do
      expect(User.find_social(nil, nil, nil, 'linkedin_door').name).to eq 'user_door_linkedin'
    end
  end
end
