class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :owner, default: false, null: false

      t.timestamps
    end
  end
end
