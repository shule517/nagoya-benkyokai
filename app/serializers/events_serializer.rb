class EventsSerializer < ActiveModel::Serializer
  attributes :id, :source, :event_id, :title, :catch, :event_url, :url, :logo_url, :started_at, :ended_at, :place, :place_enc, :address, :lat, :lon, :limit, :accepted, :waiting, :group_id, :group_title, :group_url, :group_logo_url, :update_time, :hash_tag, :twitter_list_name, :twitter_list_url, :created_at, :updated_at
  has_many :users
end
