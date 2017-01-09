class AddColumnEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :tweeted_new, :boolean, default: false, null: false
    add_column :events, :tweeted_tomorrow, :boolean, default: false, null: false
  end
end
