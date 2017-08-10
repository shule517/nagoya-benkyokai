module V1
  module Entities
    class UsersEntity < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :name, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :image_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :connpass_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :atnd_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :twitter_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :github_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :facebook_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :linkedin_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :created_at, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :updated_at, documentation: { type: Integer, desc: 'ユーザーid' }
    end
  end
end
