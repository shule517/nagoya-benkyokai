module V1
  module Entities
    class EventsEntity < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :source, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :event_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :title, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :catch, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :event_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :logo_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :started_at, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :ended_at, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :place, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :place_enc, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :address, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :lat, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :lon, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :limit, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :accepted, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :waiting, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :group_id, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :group_title, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :group_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :group_logo_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :update_time, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :hash_tag, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :twitter_list_name, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :twitter_list_url, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :created_at, documentation: { type: Integer, desc: 'ユーザーid' }
      expose :updated_at, documentation: { type: Integer, desc: 'ユーザーid' }

      # has_many :users
    end
  end
end
