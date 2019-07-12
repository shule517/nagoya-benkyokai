class DeleteIndexToParticipant < ActiveRecord::Migration[5.0]
  def change
    remove_index :participants, :owner
    remove_index :events, :started_at
    remove_index :events, :event_url
  end
end
