class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer  :group_id,     :null => false
      t.string   :name,         :null => false, :limit =>  50
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
