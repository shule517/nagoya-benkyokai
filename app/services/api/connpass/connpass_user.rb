require './app/services/api/user_base'

module Api
  module Connpass
    class ConnpassUser < UserBase
      def find_or_create_by
        result = User.find_connpass(connpass_id, twitter_id, facebook_id, github_id)
        if result
          result.connpass_id = connpass_id if connpass_id.present?
          result.twitter_id = twitter_id   if twitter_id.present?
          result.facebook_id = facebook_id if facebook_id.present?
          result.github_id = github_id     if github_id.present?
          result.image_url = image_url     if image_url.present? && image_url !~ /user_no_image/
          result.save
          return result
        else
          return User.create(connpass_id: connpass_id, twitter_id: twitter_id, facebook_id: facebook_id, github_id: github_id, name: name, image_url: image_url)
        end
      end
    end
  end
end
