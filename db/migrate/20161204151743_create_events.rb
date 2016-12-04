class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :event_id
      t.string :title
      t.string :catch
      t.string :description
      t.string :event_url
      t.string :started_at
      t.string :ended_at
      t.string :url
      t.string :address
      t.string :place
      t.string :lat
      t.string :lon
      t.string :limit
      t.string :accepted
      t.string :waiting
      t.string :updated_at
      t.string :hash_tag
      t.string :place_enc
      t.string :source
      t.string :catch
      t.string :group_url
      t.string :group_id
      t.string :group_title
      t.string :group_logo
      t.string :logo

      t.timestamps
    end
  end
end
