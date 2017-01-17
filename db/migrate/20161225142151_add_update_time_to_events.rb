class AddUpdateTimeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :update_time, :string
  end
end
