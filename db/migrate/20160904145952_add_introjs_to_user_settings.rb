class AddIntrojsToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :show_intro, :boolean, default: true
  end
end
