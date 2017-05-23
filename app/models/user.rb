class User < ApplicationRecord
  has_many :participants
  has_many :events, through: :participants

  def self.find_connpass(connpass_id, twitter_id = nil, facebook_id = nil, github_id = nil)
    user = User.find_by(connpass_id: connpass_id) if connpass_id.present?
    return user if user
    find_social(twitter_id, facebook_id, github_id)
  end

  def self.find_atnd(atnd_id, twitter_id = nil, facebook_id = nil)
    user = User.find_by(atnd_id: atnd_id) if atnd_id.present?
    return user if user
    find_social(twitter_id, facebook_id)
  end

  def self.find_doorkeeper(twitter_id = nil, facebook_id = nil, github_id = nil, linkedin_id = nil, name = nil)
    user = find_social(twitter_id, facebook_id, github_id, linkedin_id)
    return user if user
    # TODO twitter_id facebook_id github_id linkedin_id 全て未設定である条件を追加すること
    User.find_by(name: name)
  end

  def self.find_social(twitter_id = nil, facebook_id = nil, github_id = nil, linkedin_id = nil)
    if twitter_id.present?
      user = User.find_by(twitter_id: twitter_id)
      return user if user
    end

    if facebook_id.present?
      user = User.find_by(facebook_id: facebook_id)
      return user if user
    end

    if github_id.present?
      user = User.find_by(github_id: github_id)
      return user if user
    end

    if linkedin_id.present?
      user = User.find_by(linkedin_id: linkedin_id)
      return user if user
    end
  end
end
