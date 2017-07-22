class ConvertDateTypeToEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :started_at, :started_at_old
    add_column :events, :started_at, :datetime

    rename_column :events, :ended_at, :ended_at_old
    add_column :events, :ended_at, :datetime

    rename_column :events, :update_time, :update_time_old
    add_column :events, :update_time, :datetime

    Event.all.each do |event|
      event.started_at = event.started_at_old.tap { |old| old.present? ? Time.parse(old) : nil }
      event.ended_at = event.ended_at_old.tap { |old| old.present? ? Time.parse(old) : nil }
      event.update_time = event.update_time_old.tap { |old| old.present? ? Time.parse(old) : nil }
      event.save
    end
  end
end
