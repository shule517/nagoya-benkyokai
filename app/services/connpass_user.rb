#encoding: utf-8
require_relative './user_base'

class ConnpassUser < UserBase
  def find_or_create_by
    result = User.find_connpass(connpass_id, twitter_id, facebook_id, github_id)
    if result
      result.connpass_id = connpass_id if connpass_id.present?
      result.twitter_id = twitter_id   if twitter_id.present?
      result.facebook_id = facebook_id if facebook_id.present?
      result.github_id = github_id     if github_id.present?
      result.save
      return result
    else
      return User.create(connpass_id: connpass_id, twitter_id: twitter_id, facebook_id: facebook_id, github_id: github_id, name: name, image_url: image_url)
    end
  end
end
