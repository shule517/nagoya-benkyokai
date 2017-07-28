class ConvertAtndIdTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :atnd_id, :atnd_id_old
    add_column :users, :atnd_id, :integer

    User.all.each do |user|
      user.atnd_id = user.atnd_id_old.tap { |old| old.present? ? old.to_i : nil }
      user.save
    end
  end
end
