class CreateEventUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :event_users do |t|
      t.references :event, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :owner, null: false

      t.timestamps
    end
  end
end
