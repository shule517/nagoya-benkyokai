module V1
  module Entities
    class UsersEntity < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'ユーザーid' }
      # expose :email, documentation: { type: String, desc: 'メールアドレス' }
      # expose :name, documentation: { type: String, desc: '名前' }
      # expose :created_at, documentation: { type: String, desc: '作成日時' }
      # expose :updated_at, documentation: { type: String, desc: '更新日時' }
    end
  end
end
