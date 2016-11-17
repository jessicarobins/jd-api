class AddIndexes < ActiveRecord::Migration
  def change
    add_foreign_key :comments, :users
    add_foreign_key :comments, :specs

    add_foreign_key :org_settings, :trackers
    add_foreign_key :org_settings, :organizations

    add_foreign_key :projects, :organizations

    add_foreign_key :specs, :projects

    add_foreign_key :tags, :tag_types
    add_foreign_key :tags, :specs

    add_foreign_key :tag_types, :tag_type_groups
    add_foreign_key :tag_types, :organizations

    add_foreign_key :tag_type_groups, :organizations

    add_foreign_key :tickets, :specs
    add_foreign_key :tickets, :trackers

    add_foreign_key :user_organizations, :users
    add_foreign_key :user_organizations, :organizations

    add_foreign_key :user_settings, :users
  end
end
