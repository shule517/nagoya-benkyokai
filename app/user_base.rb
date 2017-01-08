#encoding: utf-8
class UserBase
  attr_reader :connpass_id,
    :atnd_id,
    :twitter_id,
    :facebook_id,
    :github_id,
    :linkedin_id,
    :name,
    :image_url

  def initialize(data)
    @connpass_id = data[:connpass_id] || ''
    @atnd_id     = data[:atnd_id]     || ''
    @twitter_id  = data[:twitter_id]  || ''
    @facebook_id = data[:facebook_id] || ''
    @github_id   = data[:github_id]   || ''
    @linkedin_id = data[:linkedin_id] || ''
    @name        = data[:name]        || ''
    @image_url   = data[:image_url]   || ''
  end
end
