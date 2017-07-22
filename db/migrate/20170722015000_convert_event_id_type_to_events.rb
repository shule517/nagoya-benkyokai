class ConvertEventIdTypeToEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :event_id, :event_id_old
    add_column :events, :event_id, :integer

    Event.all.each do |event|
      event.event_id = event.event_id_old.to_i
      event.save
    end
  end
end
