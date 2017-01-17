class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :connpass_id
      t.string :atnd_id
      t.string :twitter_id
      t.string :facebook_id
      t.string :github_id
      t.string :linkedin_id
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
