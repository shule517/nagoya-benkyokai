class RemoveOldLatLonFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :lat_old, :string
    remove_column :events, :lon_old, :string
  end
end
