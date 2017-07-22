class RenameLogoColumnToEvent < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :logo, :logo_url
    rename_column :events, :group_logo, :group_logo_url
  end
end
