class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string   :name,         :null => false, :limit =>  50
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
