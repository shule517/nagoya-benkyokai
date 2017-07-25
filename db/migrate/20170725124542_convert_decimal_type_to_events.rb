class ConvertDecimalTypeToEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :lat, :lat_old
    add_column :events, :lat, :decimal, precision: 17, scale: 14

    rename_column :events, :lon, :lon_old
    add_column :events, :lon, :decimal, precision: 17, scale: 14

    Event.all.each do |event|
      event.lat = event.lat_old.tap { |old| old.present? ? old.to_f : nil }
      event.lon = event.lon_old.tap { |old| old.present? ? old.to_f : nil }
      event.save
    end
  end
end
