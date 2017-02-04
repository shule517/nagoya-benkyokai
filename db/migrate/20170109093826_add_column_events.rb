class AddColumnEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :tweeted_new, :boolean, default: false, null: false
    add_column :events, :tweeted_tomorrow, :boolean, default: false, null: false

    # 過去データの変更
    # tweeted_new: 全てtrue
    # tweeted_tomorrow: 開催されていないイベントをtrue
    time = Time.now
    time += 24 * 60 * 60
    tommorow = time.strftime("%Y-%m-%d")
    Event.all.update_all(tweeted_new: true)
    Event.all.where("started_at < ?", tommorow).update_all(tweeted_tomorrow: true)
  end
end
