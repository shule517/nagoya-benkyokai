require_relative './user_base'

class DoorkeeperUser < UserBase
  def find_or_create_by
    result = User.find_doorkeeper(twitter_id, facebook_id, github_id, linkedin_id, name)
    if result
      result.twitter_id = twitter_id    if twitter_id.present?
      result.facebook_id = facebook_id  if facebook_id.present?
      result.github_id = github_id      if github_id.present?
      result.linkedin_id = linkedin_id  if linkedin_id.present?
      result.name = name                if name.present?
      result.image_url = image_url      if image_url.present? && image_url !~ /secure\.gravatar\.com/
      result.save
      return result
    else
      return User.create(twitter_id: twitter_id, facebook_id: facebook_id, github_id: github_id, linkedin_id: linkedin_id, name: name, image_url: image_url)
    end
  end
end
