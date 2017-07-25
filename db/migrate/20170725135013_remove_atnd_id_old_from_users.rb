class RemoveAtndIdOldFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :atnd_id_old, :string
  end
end
