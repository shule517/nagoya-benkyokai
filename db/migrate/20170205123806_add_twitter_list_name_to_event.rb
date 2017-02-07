class AddTwitterListNameToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :twitter_list_name, :string
    add_column :events, :twitter_list_url, :string
  end
end
