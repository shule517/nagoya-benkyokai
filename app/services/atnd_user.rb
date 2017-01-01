#encoding: utf-8
require_relative './user_base'

class AtndUser < UserBase
  def find_or_create_by
    User.find_or_create_by(atnd_id: atnd_id, twitter_id: twitter_id, name: name, image_url: image_url)
  end
end
