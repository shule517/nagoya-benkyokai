class ConvertTypeToEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :limit, :limit_old
    add_column :events, :limit, :integer

    rename_column :events, :accepted, :accepted_old
    add_column :events, :accepted, :integer

    rename_column :events, :waiting, :waiting_old
    add_column :events, :waiting, :integer

    rename_column :events, :group_id, :group_id_old
    add_column :events, :group_id, :integer

    Event.all.each do |event|
      event.limit = event.limit_old.tap { |old| old.present? ? old.to_i : nil }
      event.accepted = event.accepted_old.tap { |old| old.present? ? old.to_i : nil }
      event.waiting = event.waiting_old.tap { |old| old.present? ? old.to_i : nil }
      event.group_id = event.group_id_old.tap { |old| old.present? ? old.to_i : nil }
      event.save
    end
  end
end
