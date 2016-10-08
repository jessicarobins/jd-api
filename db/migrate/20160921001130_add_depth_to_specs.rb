class AddDepthToSpecs < ActiveRecord::Migration
  def change
    add_column :specs, :ancestry_depth, :integer, :default => 0
    Spec.rebuild_depth_cache!
  end
end
