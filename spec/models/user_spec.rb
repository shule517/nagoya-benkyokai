require 'rails_helper'

describe User do
  #connpass
  User.create(name: 'user1', connpass_id: '1', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: '')
  User.create(name: 'user2', connpass_id: '2', twitter_id: 'twitter1', facebook_id: '', github_id: '', linkedin_id: '')
  User.create(name: 'user3', connpass_id: '3', twitter_id: '', facebook_id: 'facebook1', github_id: '', linkedin_id: '')
  User.create(name: 'user4', connpass_id: '4', twitter_id: '', facebook_id: '', github_id: 'github1', linkedin_id: '')

  #atnd
  User.create(name: 'user5', atnd_id: '1', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: '')
  User.create(name: 'user6', atnd_id: '2', twitter_id: 'twitter2', facebook_id: '', github_id: '', linkedin_id: '')
  User.create(name: 'user7', atnd_id: '3', twitter_id: '', facebook_id: 'facebook2', github_id: '', linkedin_id: '')
  User.create(name: 'user8', atnd_id: '4', twitter_id: '', facebook_id: '', github_id: 'github2', linkedin_id: '')

  #Doorkeeper
  User.create(name: 'user9', twitter_id: 'twitter3', facebook_id: '', github_id: '', linkedin_id: '')
  User.create(name: 'user10', twitter_id: '', facebook_id: 'facebook3', github_id: '', linkedin_id: '')
  User.create(name: 'user11', twitter_id: '', facebook_id: '', github_id: 'github3', linkedin_id: '')
  User.create(name: 'user12', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: 'linkedin3')
  User.create(name: 'user13', twitter_id: '', facebook_id: '', github_id: '', linkedin_id: '')

  describe '#find_connpass' do
    it('connpass-idで紐づけ') { expect(User.find_connpass('1', '', '', ''        ).name).to eq 'user1' }
    it('twitter-idで紐づけ')  { expect(User.find_connpass('', 'twitter1', '', '' ).name).to eq 'user2' }
    it('facebook-idで紐づけ') { expect(User.find_connpass('', '', 'facebook1', '').name).to eq 'user3' }
    it('github-idで紐づけ')   { expect(User.find_connpass('', '', '', 'github1'  ).name).to eq 'user4' }
  end

  describe '#find_atnd' do
    it('atnd-idで紐づけ')     { expect(User.find_atnd('1', '', ''        ).name).to eq 'user5' }
    it('twitter-idで紐づけ')  { expect(User.find_atnd('', 'twitter2', '' ).name).to eq 'user6' }
    it('facebook-idで紐づけ') { expect(User.find_atnd('', '', 'facebook2').name).to eq 'user7' }
  end

  describe '#find_doorkeeper' do
    it('twitter-idで紐づけ')  { expect(User.find_doorkeeper('twitter3', '', '', ''     ).name).to eq 'user9'  }
    it('facebook-idで紐づけ') { expect(User.find_doorkeeper('', 'facebook3', '', ''    ).name).to eq 'user10' }
    it('github-idで紐づけ')   { expect(User.find_doorkeeper('', '', 'github3', '', ''  ).name).to eq 'user11' }
    it('linkedin-idで紐づけ') { expect(User.find_doorkeeper('', '', '', 'linkedin3', '').name).to eq 'user12' }
    it('名前で紐づけ')        { expect(User.find_doorkeeper('', '', '', '', 'user13'   ).name).to eq 'user13' }
  end

  describe '#find_social' do
    it('twitter-idで紐づけ')  { expect(User.find_social('twitter3', '', ''     ).name).to eq 'user9'  }
    it('facebook-idで紐づけ') { expect(User.find_social('', 'facebook3', ''    ).name).to eq 'user10' }
    it('github-idで紐づけ')   { expect(User.find_social('', '', 'github3'      ).name).to eq 'user11' }
    it('linked-idで紐づけ')   { expect(User.find_social('', '', '', 'linkedin3').name).to eq 'user12' }
  end
end
