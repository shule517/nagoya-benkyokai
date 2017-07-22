class RemoveOldFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :event_id_old, :string
    remove_column :events, :started_at_old, :string
    remove_column :events, :ended_at_old, :string
    remove_column :events, :limit_old, :string
    remove_column :events, :accepted_old, :string
    remove_column :events, :waiting_old, :string
    remove_column :events, :group_id_old, :string
    remove_column :events, :update_time_old, :string
  end
end
