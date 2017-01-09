class AddColumnEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :tweeted_new, :boolean
    add_column :events, :tweeted_tomorrow, :boolean
  end
end
