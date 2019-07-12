class AddIndexToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_index :participants, :owner
    add_index :events, :started_at
    add_index :events, :event_url
  end
end
