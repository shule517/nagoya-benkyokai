require './app/services/api/user_base'

module Api
  module Atnd
    class AtndUser < UserBase
      def find_or_create_by
        result = User.find_atnd(atnd_id, twitter_id, facebook_id)
        if result
          result.atnd_id = atnd_id          if atnd_id.present?
          result.twitter_id = twitter_id    if twitter_id.present?
          result.facebook_id = facebook_id  if facebook_id.present?
          result.image_url = image_url      if image_url.present? && image_url !~ /default_latent/
          result.save
          return result
        else
          return User.create(atnd_id: atnd_id, twitter_id: twitter_id, facebook_id: facebook_id, name: name, image_url: image_url)
        end
      end
    end
  end
end
