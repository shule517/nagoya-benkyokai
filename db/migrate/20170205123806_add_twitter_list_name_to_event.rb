class AddTwitterListNameToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :twitter_list_name, :string
    add_column :events, :twitter_list_url, :string

    # 初期値を設定
    Event.all.each do |event|
      event.twitter_list_name = "nagoya-#{event.event_id}"
      event.twitter_list_url = "https://twitter.com/nagoya_lambda/nagoya-#{event.event_id}"
      event.save
    end
  end
end
